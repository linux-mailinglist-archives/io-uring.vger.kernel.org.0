Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0827A6E7FBA
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 18:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbjDSQfQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 12:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbjDSQfP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 12:35:15 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5978D194
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 09:35:14 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-63b78525ac5so19312b3a.0
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 09:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681922114; x=1684514114;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SUGaDOOmXNYN2yHd8jG9FzTaVM1k9cQjYdodgvTsUtw=;
        b=4G5AVCis88GRFMkQH7k33qpndsa8jiW1+hkXHkB855AulFlcz9sIUdBnvtVl0EfH8u
         yhAB/jb56huXnr7MeumIhfLTOi5WGTDmEiWxjNr0gKwSg/1eYNn2Y03tLkrJRwUaUdP/
         R6RrUZ7g2af+Qc8aK/gYFN6Xiq6/y5Syf1dZ2dCrAr23ECOUl1JbRHCKN/cIEJW1ZR9T
         w4aBrFkOTvlmVuPQC2ZlKhL4x1V3buvqx95T7wNM6Aw5QyjbK88huTsrH3NAjAc+VQbd
         aG/5brt4HAVaXjEYnvvqp/Y0raUcrqaCo2EpOOicMDXS1aVMT2Mc3X1EQ2U8VCneA0lK
         uifw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681922114; x=1684514114;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SUGaDOOmXNYN2yHd8jG9FzTaVM1k9cQjYdodgvTsUtw=;
        b=f8guxC+rNTKjeJ+BTAlHtBo9dxvWE/uZusJ3kzKHH8bm0ZEsR4yD+G26W3hDf/RQe1
         ajnd8zcuXo5vIrhASkXbMBm9JKnsWea2Iw2tsvWuOekY2tuUN8ZU7KmeH1HmmawJBEvu
         D0aNatHsaExGQLnNiRKlljgb02xeLcdTF5deKtfhKGlWJocyNlgNoLvws+/H+rdDA6wj
         gy8BMCIRFuoCVNfvYW5ESifsNdPxcy+WmI52QbQX6tXu7L7FsGEEUTT7w/F38wGqw33J
         NKA05i14nSlWBGNs0JfgD+ZqztnlIBsqrh5ZMX1uZBfyBuw7tHnqTZr+H7Fgu2hRe/Tu
         mIxQ==
X-Gm-Message-State: AAQBX9eOzJG5i3Lshi4Q/O2syGtCIoeppL2Sk03bGJ0VroqvaacvKMzi
        4KkEOagnBguxOvXVs7H3TuI6T8KrL4bgs8438pk=
X-Google-Smtp-Source: AKy350Y932E9xmmBE5e8pOSX4ZKSOAjNxtsTMF8OQ+EM9gzlSgibHjZjdv62HJqD9m7AT2/OGwS7Cg==
X-Received: by 2002:a17:902:e751:b0:1a0:7663:731b with SMTP id p17-20020a170902e75100b001a07663731bmr22364437plf.5.1681922113778;
        Wed, 19 Apr 2023 09:35:13 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m3-20020a17090a920300b00230ffcb2e24sm1603926pjo.13.2023.04.19.09.35.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 09:35:13 -0700 (PDT)
Message-ID: <936e8f52-00be-6721-cb3e-42338f2ecc2f@kernel.dk>
Date:   Wed, 19 Apr 2023 10:35:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v4 4/6] io_uring: rsrc: avoid use of vmas parameter in
 pin_user_pages()
Content-Language: en-US
To:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <cover.1681831798.git.lstoakes@gmail.com>
 <956f4fc2204f23e4c00e9602ded80cb4e7b5df9b.1681831798.git.lstoakes@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <956f4fc2204f23e4c00e9602ded80cb4e7b5df9b.1681831798.git.lstoakes@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/18/23 9:49?AM, Lorenzo Stoakes wrote:
> We are shortly to remove pin_user_pages(), and instead perform the required
> VMA checks ourselves. In most cases there will be a single VMA so this
> should caues no undue impact on an already slow path.
> 
> Doing this eliminates the one instance of vmas being used by
> pin_user_pages().

First up, please don't just send single patches from a series. It's
really annoying when you are trying to get the full picture. Just CC the
whole series, so reviews don't have to look it up separately.

So when you're doing a respin for what I'll mention below and the issue
that David found, please don't just show us patch 4+5 of the series.

> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 7a43aed8e395..3a927df9d913 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1138,12 +1138,37 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
>  	return ret;
>  }
>  
> +static int check_vmas_locked(unsigned long addr, unsigned long len)
> +{
> +	struct file *file;
> +	VMA_ITERATOR(vmi, current->mm, addr);
> +	struct vm_area_struct *vma = vma_next(&vmi);
> +	unsigned long end = addr + len;
> +
> +	if (WARN_ON_ONCE(!vma))
> +		return -EINVAL;
> +
> +	file = vma->vm_file;
> +	if (file && !is_file_hugepages(file))
> +		return -EOPNOTSUPP;
> +
> +	/* don't support file backed memory */
> +	for_each_vma_range(vmi, vma, end) {
> +		if (vma->vm_file != file)
> +			return -EINVAL;
> +
> +		if (file && !vma_is_shmem(vma))
> +			return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}

I really dislike this naming. There's no point to doing locked in the
naming here, it just makes people think it's checking whether the vmas
are locked. Which is not at all what it does. Because what else would we
think, there's nothing else in the name that suggests what it is
actually checking.

Don't put implied locking in the naming, the way to do that is to do
something ala:

lockdep_assert_held_read(&current->mm->mmap_lock);

though I don't think it's needed here at all, as there's just one caller
and it's clearly inside. You could even just make a comment instead.

So please rename this to indicate what it's ACTUALLY checking.

-- 
Jens Axboe

