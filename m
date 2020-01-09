Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBA5135BB3
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2020 15:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730146AbgAIOvb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jan 2020 09:51:31 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:54569 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbgAIOvb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jan 2020 09:51:31 -0500
Received: by mail-pj1-f68.google.com with SMTP id kx11so1241881pjb.4
        for <io-uring@vger.kernel.org>; Thu, 09 Jan 2020 06:51:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=siyrmGK/GLa09IZDzqqPsAT0f528oev3Br0KKZWDoco=;
        b=v7b0GorCsUeyIcg8GSr2vWx5nt1qsvMWMwIxMzy84JLU9tqs6Egx/qMBbz7Xoz1R7O
         vnpR9Q9yURJVZ0FELNRixtcN1tc98W1tHjczLGfNt4pwoVD5gEQ6E04qzofAAEhn3Ftt
         z5Vi9eygxZRv/Em7Qjdt+xuCoEJfT52h4NiCQo+fGO9AxzOzDxapjDpgpG6rAISm+jIV
         Mo30nya9AiLawrGUc17GEiYCuhzsRTsbcD8vklAIWkK94uk1HLZZD+yNkyB9yq46d7SP
         OEMOFBMPypAApERRexorw7FxR+QcGl8OiA8kJXAhH8UWlw3n0It7CsyscpK8ttAVpkZD
         Ps6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=siyrmGK/GLa09IZDzqqPsAT0f528oev3Br0KKZWDoco=;
        b=DcuPqux6mIuwLX3qiwsGlJkCBOQNxOnDKQPY+pTLD3V4+jjeOOO4V01/KBQIA21lN6
         xCYilBjxckNKHlFgTsIZR3c8ZTZeOYsDS2ulos5QCuR1HXB7i8JI7jTjUgAVbUHJTfzp
         1tZ5dAMqruGFlxiHZVlKTMYC63xDMrlWKn2neCHXeOdKkzllpBjhOJW0fJ2uWksCPycH
         /CMYbhIHnqUezjijveJ6TaUv6+E1Qm76g1lxb4wuwT4ixuMbK0++qK5jmIerGzT4pzLd
         InJBpZcqizo6emcuEVUCgbzWkP4FSBuL3Xr4WstzDV5HExc02nVmvrQzvdPNxmPZaErP
         3Gzw==
X-Gm-Message-State: APjAAAVzzhgSR137rqOmwn3aWnu6O6dZNnSXvsFGwpJBRvSRX1k+0Xg7
        gOxhsvUuns0uctEUgbS8ba2fXdCHZ7g=
X-Google-Smtp-Source: APXvYqyc0H4dH2NAc+YMGzVRYoiRglxdtqx0x9M17SrjJWvKhp1YJfk9luVXX87fheP7AYGmx9nXGQ==
X-Received: by 2002:a17:90a:cb8c:: with SMTP id a12mr5795478pju.71.1578581490741;
        Thu, 09 Jan 2020 06:51:30 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id m128sm8332978pfm.183.2020.01.09.06.51.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 06:51:30 -0800 (PST)
Subject: Re: [RFC] Check if file_data is initialized
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dmitrii Dolgov <9erthalion6@gmail.com>,
        io-uring@vger.kernel.org
References: <20200109131750.30468-1-9erthalion6@gmail.com>
 <e6cd2afe-565f-8cde-652c-26c52b888962@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <07aeb2b5-b459-746b-30a2-b63550b288df@kernel.dk>
Date:   Thu, 9 Jan 2020 07:51:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <e6cd2afe-565f-8cde-652c-26c52b888962@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/9/20 7:26 AM, Pavel Begunkov wrote:
> On 1/9/2020 4:17 PM, Dmitrii Dolgov wrote:
>> With combination of --fixedbufs and an old version of fio I've managed
>> to get a strange situation, when doing io_iopoll_complete NULL pointer
>> dereference on file_data was caused in io_free_req_many. Interesting
>> enough, the very same configuration doesn't fail on a newest version of
>> fio (the old one is fc220349e4514, the new one is 2198a6b5a9f4), but I
>> guess it still makes sense to have this check if it's possible to craft
>> such request to io_uring.
> 
> I didn't looked up why it could become NULL in the first place, but the
> problem is probably deeper.
> 
> 1. I don't see why it puts @rb->to_free @file_data->refs, even though
> there could be non-fixed reqs. It needs to count REQ_F_FIXED_FILE reqs
> and put only as much.

Agree on the fixed file refs, there's a bug there where it assumes they
are all still fixed. See below - Dmitrii, use this patch for testing
instead of the other one!

> 2. Jens, there is another line bothering me, could you take a look?
> 
> io_free_req_many()
> {
> ...
> 	if (req->flags & REQ_F_INFLIGHT) ...;
> 	else
> 		rb->reqs[i] = NULL;
> ...
> }
> 
> It zeroes rb->reqs[i], calls __io_req_aux_free(), but did not free
> memory for the request itself. Is it as intended?

We free them at the end of that function, in bulk. But we can't do that
with the aux data.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 32aee149f652..b5dcf6c800ef 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1218,6 +1218,8 @@ struct req_batch {
 
 static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
 {
+	int fixed_refs = 0;
+
 	if (!rb->to_free)
 		return;
 	if (rb->need_iter) {
@@ -1227,8 +1229,10 @@ static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
 		for (i = 0; i < rb->to_free; i++) {
 			struct io_kiocb *req = rb->reqs[i];
 
-			if (req->flags & REQ_F_FIXED_FILE)
+			if (req->flags & REQ_F_FIXED_FILE) {
 				req->file = NULL;
+				fixed_refs++;
+			}
 			if (req->flags & REQ_F_INFLIGHT)
 				inflight++;
 			else
@@ -1255,8 +1259,9 @@ static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
 	}
 do_free:
 	kmem_cache_free_bulk(req_cachep, rb->to_free, rb->reqs);
+	if (fixed_refs)
+		percpu_ref_put_many(&ctx->file_data->refs, fixed_refs);
 	percpu_ref_put_many(&ctx->refs, rb->to_free);
-	percpu_ref_put_many(&ctx->file_data->refs, rb->to_free);
 	rb->to_free = rb->need_iter = 0;
 }

-- 
Jens Axboe

