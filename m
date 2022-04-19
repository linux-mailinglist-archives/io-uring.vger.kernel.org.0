Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6573E507191
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 17:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353779AbiDSPXx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 11:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353786AbiDSPXw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 11:23:52 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33F92DAAC
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 08:21:05 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id n134so12911914iod.5
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 08:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=/SsNF3JqKTNj5pJlqjhpmBT/+FGAwvrf75iWpNuZOOU=;
        b=QO+RjwqqaN/R+MEK4X1Ql+65cldum3UxRKAknR5fCn8md/Sb8R9ShfZQIe+Chqw9w0
         dRPJ08zwZhTP86tG9UZOPH/1ySyNxWgZEw7it3bMpO9zp+h1FUl442S+Pk4s0F5yw582
         wUUW5ScyqN5hO0nueCDMjIZfSEmpBg+1BEbFKeRbxffU640sPAPFg3khJqKdJGaV+JZp
         W0ubTfKMDqyaMkOOhsCZLAvUZU8kyjUHAdSmqpInJj+3CuDyn/e/cakoTJA5DSdNQ7ww
         lpbmPY04TkToYEeAJofb0JS4jyAer45StYbsSTSWknPvKn6b51woC6CWdFRvvgWb8/Yw
         TgSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=/SsNF3JqKTNj5pJlqjhpmBT/+FGAwvrf75iWpNuZOOU=;
        b=MvNJQYPeVzt9hRJkSzh7nowrIwYxGtmyHe3cHHKyd1erQdeGbN/GIClZNoFzWXXCkS
         +vVbye9dtd9C43sa4H7Q2s34Ce9hYI9tLN+Bd5c/115r30oseZZ80k72k169orHIBa96
         IbgkfU7gIiFCzJUYzDFukpg+/pe2xRUBLFFcWvKDzxdf413fFA4Zi4r5VUffuFpLNAsF
         bkeLk18VJlEhqC7Iob+QDCrKHQQEW6oWApqPyo7gj5ntzzklZQo7JtG7B+vW9d2mDzQK
         2azhnKyimHagG9fVmLElAQYrM9SFIwWPSwvvUFCxSTSmFTgbcT/7xexLOL6oGHr9oYlc
         HX9g==
X-Gm-Message-State: AOAM5329N3dWpy74FYNUQVW8oQmuOMjCKcVAq+Sm5kLeqYFY46m3E1W7
        poUrXDCwJUg/8TFglhTHJsOXt96+d3Jqtg==
X-Google-Smtp-Source: ABdhPJxH1l+GvLtLtrCMNuxPFj3u9EFyXwQC7h907UTd+RTGb1d2jBkH7JBSEnYjUk6y6ostZyL//Q==
X-Received: by 2002:a05:6638:3012:b0:317:9a63:ecd3 with SMTP id r18-20020a056638301200b003179a63ecd3mr8394452jak.210.1650381664824;
        Tue, 19 Apr 2022 08:21:04 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id 8-20020a92c648000000b002cbde5445f6sm8924025ill.67.2022.04.19.08.21.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 08:21:03 -0700 (PDT)
Message-ID: <16030f8f-67b1-dbc9-0117-47c16bf78c34@kernel.dk>
Date:   Tue, 19 Apr 2022 09:21:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: IORING_OP_POLL_ADD slower than linux-aio IOCB_CMD_POLL
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Avi Kivity <avi@scylladb.com>, io-uring@vger.kernel.org
References: <9b749c99-0126-f9b2-99f5-5c33433c3a08@scylladb.com>
 <9e277a23-84d7-9a90-0d3e-ba09c9437dc4@kernel.dk>
 <e7ffdf1e-b6a8-0e46-5879-30c25446223d@scylladb.com>
 <b585d3b4-42b3-b0db-1cef-5d6c8b815bb7@kernel.dk>
 <e90bfb07-c24f-0e4d-0ac6-bd67176641fb@scylladb.com>
 <8e816c1b-213b-5812-b48a-a815c0fe2b34@kernel.dk>
In-Reply-To: <8e816c1b-213b-5812-b48a-a815c0fe2b34@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/19/22 6:31 AM, Jens Axboe wrote:
> On 4/19/22 6:21 AM, Avi Kivity wrote:
>> On 19/04/2022 15.04, Jens Axboe wrote:
>>> On 4/19/22 5:57 AM, Avi Kivity wrote:
>>>> On 19/04/2022 14.38, Jens Axboe wrote:
>>>>> On 4/19/22 5:07 AM, Avi Kivity wrote:
>>>>>> A simple webserver shows about 5% loss compared to linux-aio.
>>>>>>
>>>>>>
>>>>>> I expect the loss is due to an optimization that io_uring lacks -
>>>>>> inline completion vs workqueue completion:
>>>>> I don't think that's it, io_uring never punts to a workqueue for
>>>>> completions.
>>>>
>>>> I measured this:
>>>>
>>>>
>>>>
>>>>   Performance counter stats for 'system wide':
>>>>
>>>>           1,273,756 io_uring:io_uring_task_add
>>>>
>>>>        12.288597765 seconds time elapsed
>>>>
>>>> Which exactly matches with the number of requests sent. If that's the
>>>> wrong counter to measure, I'm happy to try again with the correct
>>>> counter.
>>> io_uring_task_add() isn't a workqueue, it's task_work. So that is
>>> expected.

Might actually be implicated. Not because it's a async worker, but
because I think we might be losing some affinity in this case. Looking
at traces, we're definitely bouncing between the poll completion side
and then execution the completion.

Can you try this hack? It's against -git + for-5.19/io_uring. If you let
me know what base you prefer, I can do a version against that. I see
about a 3% win with io_uring with this, and was slower before against
linux-aio as you saw as well.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index caa5b673f8f5..f3da6c9a9635 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6303,6 +6303,25 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 		io_req_complete_failed(req, ret);
 }
 
+static bool __io_poll_execute_direct(struct io_kiocb *req, int mask, int events)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (ctx->has_evfd || req->flags & REQ_F_INFLIGHT ||
+	    req->opcode != IORING_OP_POLL_ADD)
+		return false;
+	if (!spin_trylock(&ctx->completion_lock))
+		return false;
+
+	req->cqe.res = mangle_poll(mask & events);
+	hash_del(&req->hash_node);
+	__io_req_complete_post(req, req->cqe.res, 0);
+	io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
+	io_cqring_ev_posted(ctx);
+	return true;
+}
+
 static void __io_poll_execute(struct io_kiocb *req, int mask, int events)
 {
 	req->cqe.res = mask;
@@ -6384,7 +6403,8 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 			else
 				req->flags &= ~REQ_F_SINGLE_POLL;
 		}
-		__io_poll_execute(req, mask, poll->events);
+		if (!__io_poll_execute_direct(req, mask, poll->events))
+			__io_poll_execute(req, mask, poll->events);
 	}
 	return 1;
 }

-- 
Jens Axboe

