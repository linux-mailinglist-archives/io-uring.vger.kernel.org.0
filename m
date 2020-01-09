Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67FCE135CA5
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2020 16:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgAIPXx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jan 2020 10:23:53 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38790 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732362AbgAIPXx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jan 2020 10:23:53 -0500
Received: by mail-pl1-f196.google.com with SMTP id f20so2693481plj.5
        for <io-uring@vger.kernel.org>; Thu, 09 Jan 2020 07:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Ci03DnRLDceIBvHpJGprC3IMUhSomddFwbWAXij7pR4=;
        b=I4mONahKS6x1L/SFxnPNUjm0styObQ90XeazaWXFEhapDkegA2f5jKnPQsumxdM3Va
         dpisth1Ydv/VhdL0fhQNIylevwX/C313Hidyk2chCQT2XaXFmgX5Y70nC6Pl0QDGuKh2
         pgoW29tN5g3nhMyOuVk+XraRSmfKMjZA5kdcqfE7zPTyMlmnRabdSZy7QRFJp9G+Xakk
         J05yu4nRA7tr9INIKbH6adrUJYf+YNgPbk52jkwjSOSDvtmwarej5FXRzuw9wNxOD6wF
         Qo+kCRskAvrOxp7/QCKQXpGhiBS0zVwlZBmi15RXtfWSbr2Zta+ce+O8eUZMxJ/ONCh6
         7oVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ci03DnRLDceIBvHpJGprC3IMUhSomddFwbWAXij7pR4=;
        b=LL8opeMIXSTBVw1HXXjrD0P1RnebYHgxNlo0hwjb0TxSj39GeOsMZs8DAzF3EeiLvH
         ciE3co6kJ95KS/esSH2Am52tLZtMlNOabwjpCDhz9VgEumwJ/B4UYRh+wvWldE7jUERC
         Xzm705tOhneCNOzWw8m+zdeY/qfQEzKPimBtg6On/YpqqWsO3xmy+AU6a9n9jTar9mJf
         tst4szLFc9o0L3vBl93JEyom+5TLZzqFDV8Um3Y4Lwa98kgCt7vuO6lLycVQnnMCLvyh
         NX7nQVTa2L4WhTeM+Ec6d2BmMGXn6hzYN+U5wBotFnwwVLg3kN6JQfWHh94neulE1l7T
         iEOA==
X-Gm-Message-State: APjAAAULGRUsKh3c/02IjqVfZiYzlI2I3Rvz3dlIBi5lZhGeNYSkcR/p
        HjHMVByUkf+SQaE16CiFhuPdtaxwByk=
X-Google-Smtp-Source: APXvYqwEAwNHogmPWevK6JIsDWRH5C34kgYe9uhqiLTmWqHe1vF51H3AT4jxIlb9Jo7TFQUpCYNUSA==
X-Received: by 2002:a17:902:8344:: with SMTP id z4mr12703992pln.41.1578583432423;
        Thu, 09 Jan 2020 07:23:52 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z13sm3851756pjz.15.2020.01.09.07.23.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 07:23:51 -0800 (PST)
Subject: Re: [RFC] Check if file_data is initialized
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dmitrii Dolgov <9erthalion6@gmail.com>,
        io-uring@vger.kernel.org
References: <20200109131750.30468-1-9erthalion6@gmail.com>
 <e6cd2afe-565f-8cde-652c-26c52b888962@gmail.com>
 <07aeb2b5-b459-746b-30a2-b63550b288df@kernel.dk>
 <73e00d5c-e36e-6614-9de1-19978efd7e61@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e44a3ebd-5f4a-ff7b-7c42-e1b5710a4edd@kernel.dk>
Date:   Thu, 9 Jan 2020 08:23:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <73e00d5c-e36e-6614-9de1-19978efd7e61@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/9/20 8:17 AM, Pavel Begunkov wrote:
> On 1/9/2020 5:51 PM, Jens Axboe wrote:
>> On 1/9/20 7:26 AM, Pavel Begunkov wrote:
>>> On 1/9/2020 4:17 PM, Dmitrii Dolgov wrote:
>>>> With combination of --fixedbufs and an old version of fio I've managed
>>>> to get a strange situation, when doing io_iopoll_complete NULL pointer
>>>> dereference on file_data was caused in io_free_req_many. Interesting
>>>> enough, the very same configuration doesn't fail on a newest version of
>>>> fio (the old one is fc220349e4514, the new one is 2198a6b5a9f4), but I
>>>> guess it still makes sense to have this check if it's possible to craft
>>>> such request to io_uring.
>>>
>>> I didn't looked up why it could become NULL in the first place, but the
>>> problem is probably deeper.
>>>
>>> 1. I don't see why it puts @rb->to_free @file_data->refs, even though
>>> there could be non-fixed reqs. It needs to count REQ_F_FIXED_FILE reqs
>>> and put only as much.
>>
>> Agree on the fixed file refs, there's a bug there where it assumes they
>> are all still fixed. See below - Dmitrii, use this patch for testing
>> instead of the other one!
>>
>>> 2. Jens, there is another line bothering me, could you take a look?
>>>
>>> io_free_req_many()
>>> {
>>> ...
>>> 	if (req->flags & REQ_F_INFLIGHT) ...;
>>> 	else
>>> 		rb->reqs[i] = NULL;
>>> ...
>>> }
>>>
>>> It zeroes rb->reqs[i], calls __io_req_aux_free(), but did not free
>>> memory for the request itself. Is it as intended?
>>
>> We free them at the end of that function, in bulk. But we can't do that
>> with the aux data.
> 
> Right, we can't do that with the aux data. But we NULL a req in the
> array, which then passed to kmem_cache_free_bulk(). So, it won't be
> visible to the *_free_bulk(). Am I missing something?
> 
> e.g.
> 1. initial reqs [req1 with files, ->io, etc]
> 2. set to NULL, so [NULL]
> 3. __io_req_aux_free(req)
> 4. bulk_free([NULL]);

Yeah that looks wrong, I don't think you're missing something. We
should just use the flags check again. I'll double check this in
testing now.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 49622a320317..d7a77830a2f2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1235,8 +1235,6 @@ static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
 			}
 			if (req->flags & REQ_F_INFLIGHT)
 				inflight++;
-			else
-				rb->reqs[i] = NULL;
 			__io_req_aux_free(req);
 		}
 		if (!inflight)
@@ -1246,7 +1244,7 @@ static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
 		for (i = 0; i < rb->to_free; i++) {
 			struct io_kiocb *req = rb->reqs[i];
 
-			if (req) {
+			if (req->flags & REQ_F_INFLIGHT)
 				list_del(&req->inflight_entry);
 				if (!--inflight)
 					break;

-- 
Jens Axboe

