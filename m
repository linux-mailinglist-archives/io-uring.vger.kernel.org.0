Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844A46E801E
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 19:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbjDSRIQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 13:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjDSRIP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 13:08:15 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405937689;
        Wed, 19 Apr 2023 10:07:14 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id a8-20020a05600c348800b003f17ddb04e3so1726740wmq.2;
        Wed, 19 Apr 2023 10:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681924032; x=1684516032;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2tMDhyZV3Hgc/Al67mw6uSm3u02DMvYwTng02dpk0J8=;
        b=LYzXyeHMRjZkwMpePS/pentjI6XWh5f4bYCE5sfZDJah2PnFG3g1CXYmQHv/bYb8xE
         UhpPzvuJvjYt/2dTACg7wxe6M9IL11BG7mftuAld3TOiZYIkLQ0asJTRZCsKhcoHqCPG
         A7lRQnDyeYnk7546nPUG+O0DN7HablK88JncWzd3etJO9Scbb+ssChcBdGa5mG3XVuD3
         Hp+LQ/B0ns0onyjPgkPo7vwoaVGn7VKf4U8iBl+CMVuVuFGSNz6TQLuUURJ3yWDJtKMV
         YkSG6XoyNNP0Nwleo+5JUG4QBfIV1ARU/FQwif5DCJ/KQFVqDR4+Z56h6Tg5jYgPjrn9
         nv/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681924032; x=1684516032;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2tMDhyZV3Hgc/Al67mw6uSm3u02DMvYwTng02dpk0J8=;
        b=YjForGDIJQoHGiaeaXLydCWQuo7mW1BfoWv/K35Y1vU9dr9U8m6MbgaJMKeza0BDvf
         TR01aOs4T+qS+Sg5iM/mUV36Od0hQ9q96gfxsv38uN5sSFPUDXz5atHA7la9F+Bnrvxo
         BtxknSAKnrwU3hBR9+qDOCosbThngOz/qOf3NUQ7qOOFLICtdyRsu3cWk0FuBuuOrdSu
         xnv009GzCgQAP48tCssRti8p+RFH6vsHj31tLSXIVLCEgu7WYA2zCOAYNSQOuoS9aQj0
         svp+3/h9K4uOYFZlJhyv2JP7j6e0oFbyfP3H0fESi7beAWI5oGujNWEPnDIlEJV6Z38S
         DdVQ==
X-Gm-Message-State: AAQBX9ea4UaHiLb8Z+8iOLPUPbWmHzSsB/In7MFhk5qOvr9XrsFmznto
        xRXJNhJuq+VfDCrC0xQOeyX1V+Ytoas=
X-Google-Smtp-Source: AKy350axLKbKSQbCVzHP1rMEE17C4ESwiyORCjzaGKv6fd66+tZj9hFbaObtfvAl7K5lZL2gGCbDBQ==
X-Received: by 2002:a7b:cb06:0:b0:3f0:9564:f4f6 with SMTP id u6-20020a7bcb06000000b003f09564f4f6mr16578277wmj.1.1681924032437;
        Wed, 19 Apr 2023 10:07:12 -0700 (PDT)
Received: from localhost ([2a00:23c5:dc8c:8701:1663:9a35:5a7b:1d76])
        by smtp.gmail.com with ESMTPSA id z13-20020a5d44cd000000b002e61e002943sm16277742wrr.116.2023.04.19.10.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 10:07:11 -0700 (PDT)
Date:   Wed, 19 Apr 2023 18:07:10 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v4 4/6] io_uring: rsrc: avoid use of vmas parameter in
 pin_user_pages()
Message-ID: <82f26c52-bff7-4f54-b5ea-2fe635045e37@lucifer.local>
References: <cover.1681831798.git.lstoakes@gmail.com>
 <956f4fc2204f23e4c00e9602ded80cb4e7b5df9b.1681831798.git.lstoakes@gmail.com>
 <936e8f52-00be-6721-cb3e-42338f2ecc2f@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <936e8f52-00be-6721-cb3e-42338f2ecc2f@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 19, 2023 at 10:35:12AM -0600, Jens Axboe wrote:
> On 4/18/23 9:49?AM, Lorenzo Stoakes wrote:
> > We are shortly to remove pin_user_pages(), and instead perform the required
> > VMA checks ourselves. In most cases there will be a single VMA so this
> > should caues no undue impact on an already slow path.
> >
> > Doing this eliminates the one instance of vmas being used by
> > pin_user_pages().
>
> First up, please don't just send single patches from a series. It's
> really annoying when you are trying to get the full picture. Just CC the
> whole series, so reviews don't have to look it up separately.
>

Sorry about that, it's hard to strike the right balance between not
spamming people and giving appropriate context, different people have
different opinions about how best to do this, in retrospect would certainly
have been a good idea to include you on all.

> So when you're doing a respin for what I'll mention below and the issue
> that David found, please don't just show us patch 4+5 of the series.

ack

>
> > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > index 7a43aed8e395..3a927df9d913 100644
> > --- a/io_uring/rsrc.c
> > +++ b/io_uring/rsrc.c
> > @@ -1138,12 +1138,37 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
> >  	return ret;
> >  }
> >
> > +static int check_vmas_locked(unsigned long addr, unsigned long len)
> > +{
> > +	struct file *file;
> > +	VMA_ITERATOR(vmi, current->mm, addr);
> > +	struct vm_area_struct *vma = vma_next(&vmi);
> > +	unsigned long end = addr + len;
> > +
> > +	if (WARN_ON_ONCE(!vma))
> > +		return -EINVAL;
> > +
> > +	file = vma->vm_file;
> > +	if (file && !is_file_hugepages(file))
> > +		return -EOPNOTSUPP;
> > +
> > +	/* don't support file backed memory */
> > +	for_each_vma_range(vmi, vma, end) {
> > +		if (vma->vm_file != file)
> > +			return -EINVAL;
> > +
> > +		if (file && !vma_is_shmem(vma))
> > +			return -EOPNOTSUPP;
> > +	}
> > +
> > +	return 0;
> > +}
>
> I really dislike this naming. There's no point to doing locked in the
> naming here, it just makes people think it's checking whether the vmas
> are locked. Which is not at all what it does. Because what else would we
> think, there's nothing else in the name that suggests what it is
> actually checking.
>
> Don't put implied locking in the naming, the way to do that is to do
> something ala:
>
> lockdep_assert_held_read(&current->mm->mmap_lock);
>
> though I don't think it's needed here at all, as there's just one caller
> and it's clearly inside. You could even just make a comment instead.
>
> So please rename this to indicate what it's ACTUALLY checking.

ack will do!

>
> --
> Jens Axboe
>
