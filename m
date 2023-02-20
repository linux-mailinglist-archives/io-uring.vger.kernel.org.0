Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725E869CF2B
	for <lists+io-uring@lfdr.de>; Mon, 20 Feb 2023 15:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbjBTOSA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Feb 2023 09:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbjBTOR7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Feb 2023 09:17:59 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2676A7EE4
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 06:17:58 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id ck15so6520304edb.0
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 06:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fxC/F7mfGDd6Y36J28Hd5CWgcnzNMF7k0CNq40LWZNw=;
        b=WoOjAwscKNYTTGVuaBfR4FDZ7geKSPcLtw2+PiXVKW7gKSuHrBnGU4NNMGj6IlJhjt
         hDvw3/wOH7cW1M66A4hhWMkPn/i08KrDLZ+r3NC2c2nDRkryEQUR4XNUd+rjm6BhSIgC
         0u/cSHgt5zh/kd7vjB5mN0Yu/gPMbeGd4Wp1ERIeyULjQ/mqIMSJQNn1Gg9Kjenio/qe
         DZQGDf8CuOpwhaCVHd+O5BeSJOWKOoVwjRe6PFeQQuWsEwqJMzD41wG8/9A5kst2u6dG
         hfOCWMDBfctMx25RKq+C1y4WpPbiF7rXlNR3vaVTsG4ZV3JXReX2UCqFbItQ0o/pBVVT
         Qonw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fxC/F7mfGDd6Y36J28Hd5CWgcnzNMF7k0CNq40LWZNw=;
        b=Rg+XN8kTV7CWLIFUI3lMp5JCqxQglfVn+XxOCwm/JU7Wlz75Bmh2q3axRG5JMwaXcf
         PtjiH2w04SvRqDZ3VnPyFlQ+pep3IvH7sYd5L95RWXCQw6vT9yivK3pH+FoxW0UqyL/C
         8joNS8/bXWnUnTCXpqlCNoZwfz97+Yw+yIsnEiYy90fR4MA8p4ovNQi0mfoVJuLrVRHQ
         CSxdODr8tcmAzW7lrUEkKmZ5NmFkhubrZJJ9oEoKeaP7C6MFN7rY/KmX1JG8aDG9pWxp
         qV/1jGf3IAIuB0mLc9doXtmNRDtibscgGRVJyXgOsXowrsRG9zKDCxq7Ksy/UY/KgrJN
         IVgA==
X-Gm-Message-State: AO0yUKXDksUNoLVsROckqwHKXoFJRbiKAvuZl2BswtENNyJjH8hEVndU
        BWw2wvQLyPGa0/NhVcY3GgvzLCvG0kM=
X-Google-Smtp-Source: AK7set8avOoxT5rUMTuSa06VxU5u1/w9luKhMAH7RhBGRcbL/k7UvU7nlvdV5a/Uxw8xW/IdpErxHA==
X-Received: by 2002:a05:6402:291:b0:4ab:4c5e:b0ed with SMTP id l17-20020a056402029100b004ab4c5eb0edmr1061590edv.21.1676902676289;
        Mon, 20 Feb 2023 06:17:56 -0800 (PST)
Received: from [192.168.8.100] (94.196.95.64.threembb.co.uk. [94.196.95.64])
        by smtp.gmail.com with ESMTPSA id y20-20020a056402441400b004acc5077026sm765673eda.79.2023.02.20.06.17.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Feb 2023 06:17:55 -0800 (PST)
Message-ID: <b0d8786d-efbb-50cd-7c8b-e70519331bcd@gmail.com>
Date:   Mon, 20 Feb 2023 14:16:30 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH for-next 1/1] io_uring/rsrc: don't mix different mappings
 in reg
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <813cdd2d15c3c471bf06c6c93a0a35315d08a3ad.1676902351.git.asml.silence@gmail.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <813cdd2d15c3c471bf06c6c93a0a35315d08a3ad.1676902351.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/23 14:13, Pavel Begunkov wrote:
> If two or more mappings go back to back to each other they can be passed
> into io_uring to be registered as a single registered buffer. That would
> even work if mappings came from different sources, e.g. it's possible to
> mix in this way anon pages and pages from shmem or hugetlb. That is not
> a problem but it'd rather be less prone if we forbid such mixing.

The commit title got botched, let me rename and resend it.


> Cc: <stable@vger.kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/rsrc.c | 15 ++++++++-------
>   1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index a59fc02de598..70d7f94670f9 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1162,18 +1162,19 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
>   	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
>   			      pages, vmas);
>   	if (pret == nr_pages) {
> +		struct file *file = vmas[0]->vm_file;
> +
>   		/* don't support file backed memory */
>   		for (i = 0; i < nr_pages; i++) {
> -			struct vm_area_struct *vma = vmas[i];
> -
> -			if (vma_is_shmem(vma))
> +			if (vmas[i]->vm_file != file)
> +				break;
> +			if (!file)
>   				continue;
> -			if (vma->vm_file &&
> -			    !is_file_hugepages(vma->vm_file)) {
> -				ret = -EOPNOTSUPP;
> +			if (!vma_is_shmem(vmas[i]) && !is_file_hugepages(file))
>   				break;
> -			}
>   		}
> +		if (i != nr_pages)
> +			ret = -EOPNOTSUPP;
>   		*npages = nr_pages;
>   	} else {
>   		ret = pret < 0 ? pret : -EFAULT;

-- 
Pavel Begunkov
