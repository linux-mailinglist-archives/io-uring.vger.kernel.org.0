Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB1469E4AA
	for <lists+io-uring@lfdr.de>; Tue, 21 Feb 2023 17:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjBUQ3z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Feb 2023 11:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234398AbjBUQ3w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Feb 2023 11:29:52 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427274EF0
        for <io-uring@vger.kernel.org>; Tue, 21 Feb 2023 08:29:23 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id d11so1940957iow.0
        for <io-uring@vger.kernel.org>; Tue, 21 Feb 2023 08:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676996961;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g4gt62ZakaEtDRbRpviyBIm1h2Twkttyr2jkmuzLS+k=;
        b=aVwzamuB+6Xy6Nhj2Vuf405YqfUQP8lkjSIImPHpF1mTALYKWuA+So7FjS4LF+R+ps
         cTzmlNqddFhylNHA8RR59c+08nfzHiG7aDGgJueRlfbcfNxpMz8lzDyMbjTTE1+skABx
         Y+wNfnoazNDEQVq65dPqQfxBnAlO/aI9sR55AMv3fi9BFdn8YEG+61Iup/HB6lekr6qo
         qFf0xRuab/SEqaK4pRae3jR6mH6e1nT3X1kvvAnRKHtUA6TLkJPbpTDFPSefNM5UbbTf
         q3UA1uVb2z3M+M+rMIb5WQsARvyyi1AtsNBLAA7wQUfvkMJGGNGjOAXgRz5OJ+npNaZ9
         6vnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676996961;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g4gt62ZakaEtDRbRpviyBIm1h2Twkttyr2jkmuzLS+k=;
        b=rn2jWLCWBob+dpMyiHigJYeH6QJwpV6y2C28j8knhzHPm0yKjRdq23KyALoSBjv7KS
         eyUf93XqME1l7X+Eg6v41LsP+IlMZq5LQvUCUI0En1kR5QGBmwHYD1NqZzh1DLuCAowq
         fVHr8kEuPlOYc/Ximc3JpU5Bhq/KUUqJ7Scq5C3tNP0k/8gAfTdAH9qTG3stfLONsEdW
         7lsM+pIOVvOoFT+Akar/AG0kj7x0TvPgVG998bM4Jmx1s7GUMqPFlMYjop1pJUiuYUzF
         VstuFkbQUmngYAGtLQ8TYK+aU+hkRROKFGndZWNU7RAKP/MmTPy7xyj8oD/ygX5nUzPv
         9N2A==
X-Gm-Message-State: AO0yUKXNl9m2gbSF9FLujSpTRFUzeCbh9w36rTDcHFQkJ9ZzzfyYvLHL
        T1KErcrFpCIqJ786nqY/CtK25g==
X-Google-Smtp-Source: AK7set/LAeneKzIhqIGzvEYiJMHEIgVXLoD1VjhjzNh9mvHJ+dqlYDYLS3fDwyzqBl5VZvEKfFBb8g==
X-Received: by 2002:a5d:9d81:0:b0:719:6a2:99d8 with SMTP id ay1-20020a5d9d81000000b0071906a299d8mr4396532iob.0.1676996961011;
        Tue, 21 Feb 2023 08:29:21 -0800 (PST)
Received: from [10.80.1.8] (h184-60-188-235.stgrut.dedicated.static.tds.net. [184.60.188.235])
        by smtp.gmail.com with ESMTPSA id t6-20020a02c906000000b003a7cbe1d235sm1194900jao.12.2023.02.21.08.29.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 08:29:20 -0800 (PST)
Message-ID: <f15b5f08-ba79-9d73-8967-74cf69930f86@kernel.dk>
Date:   Tue, 21 Feb 2023 09:29:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH for-next v2 1/1] io_uring/rsrc: disallow multi-source reg
 buffers
Content-Language: en-US
To:     Gabriel Krisman Bertazi <krisman@suse.de>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <6d973a629a321aa73c286f2d64d5375327d5c02a.1676902832.git.asml.silence@gmail.com>
 <87y1oscrsj.fsf@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87y1oscrsj.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/23 7:53 AM, Gabriel Krisman Bertazi wrote:
> Pavel Begunkov <asml.silence@gmail.com> writes:
> 
>> If two or more mappings go back to back to each other they can be passed
>> into io_uring to be registered as a single registered buffer. That would
>> even work if mappings came from different sources, e.g. it's possible to
>> mix in this way anon pages and pages from shmem or hugetlb. That is not
>> a problem but it'd rather be less prone if we forbid such mixing.
>>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  io_uring/rsrc.c | 15 ++++++++-------
>>  1 file changed, 8 insertions(+), 7 deletions(-)
>>
>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>> index a59fc02de598..70d7f94670f9 100644
>> --- a/io_uring/rsrc.c
>> +++ b/io_uring/rsrc.c
>> @@ -1162,18 +1162,19 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
>>  	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
>>  			      pages, vmas);
>>  	if (pret == nr_pages) {
>> +		struct file *file = vmas[0]->vm_file;
>> +
>>  		/* don't support file backed memory */
>>  		for (i = 0; i < nr_pages; i++) {
>> -			struct vm_area_struct *vma = vmas[i];
>> -
>> -			if (vma_is_shmem(vma))
>> +			if (vmas[i]->vm_file != file)
>> +				break;
> 
> Perhaps, return -EINVAL instead of -EOPNOTSUPP

Agree, -EOPNOTSUPP is OK for an unsupported case, but I think
-EINVAL makes more sense for the weird case of mixed sources
as it's unlikely to ever make sense to support that.

-- 
Jens Axboe


