Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A12815CF3E
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 01:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgBNAyH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Feb 2020 19:54:07 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33568 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727595AbgBNAyH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Feb 2020 19:54:07 -0500
Received: by mail-pg1-f194.google.com with SMTP id 6so4061217pgk.0
        for <io-uring@vger.kernel.org>; Thu, 13 Feb 2020 16:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=e09CtNFrRkolRzJfCkZuYsDnudDYJybj24UtU6uqsFM=;
        b=XTUujSzbDq9wRdqkByqlsT0L3ym6UAY0KjrX4YJOvK+3Kkb2bOMx92/2CDtuPaubNN
         vgZLCsASfS9PgJbFilwatsdHL+/I4IS/G5HOigYtlVHOvXIZqaWbu2I7wFh9HXZzMmQQ
         ztLydw7lf+vW86DnyT1qmLG8GIYzwNTG30IzYxK9u1ugNw6DIcDm/SP4vzdNKVggceD8
         h4n6cWsWJHG/P5sGhqFgiroeFjaQmVqFioWdSV+f+OOd8VpL9eDjGX0Abc+UgFkRoR6G
         DJfBHcU4ARK45HvWt7M5kx2C6nrSEzWz3ydMVeNTKpLqpEdsdxNbHcnBgvD9EX2+AHit
         f9qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e09CtNFrRkolRzJfCkZuYsDnudDYJybj24UtU6uqsFM=;
        b=hcb57cFjuF24+eEIraXy3v4COavalSlk3MXf2SefhRHKuDy+ASGUrMP7qtPEgmgLBM
         bpV48ZWXfXzI5cyzPKeGU5XGxSO/vp9rEQINjV9ujbNCynaaJFpr9JDhp1x8O6NYWzFj
         1YmcTt4c6eF6lC5BwUyeHp9RIyHWr9Yp3J4R93swzuFS86xTjcTCDRYUIpYmNX4SClYz
         4sLaFRkgTbq1/Q2PZqu+cevPIKbbQNoUIY7xxpBsQ9VtN4UvOk2Zyt2C49ilCxLKmHoP
         s6rm4l+bkUegJGcljkP6w/agedGrzbkxgnZ47W9eIx9aWkJXO0fbqyXHV/ihcNqnshHu
         XDrg==
X-Gm-Message-State: APjAAAUmwPpe1TulbcFJ09VcTZq4P7wc2bGzK2ltHUImV/Pu1F9ewNDq
        SMQJgVTMJMlLO7R2kwOdK593GKXgoS5HhA==
X-Google-Smtp-Source: APXvYqxHcqZ6wJUjI9GStXc6nRZWNgSc8OT1f/0zrJWo8eHmLinEVL7YzV4kMzOWGG1H82Tri63LKA==
X-Received: by 2002:a63:fe4d:: with SMTP id x13mr641331pgj.147.1581641645199;
        Thu, 13 Feb 2020 16:54:05 -0800 (PST)
Received: from [172.20.10.2] ([107.72.97.20])
        by smtp.gmail.com with ESMTPSA id a5sm3636697pjh.7.2020.02.13.16.54.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 16:54:04 -0800 (PST)
Subject: Re: [PATCH] io_uring: prune request from overflow list on flush
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring <io-uring@vger.kernel.org>,
        =?UTF-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>
References: <01ae4ae7-0cbb-389b-8ee9-f561b3df1d6a@kernel.dk>
Message-ID: <03adb172-b58d-147e-4955-b79422bc1e93@kernel.dk>
Date:   Thu, 13 Feb 2020 17:51:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <01ae4ae7-0cbb-389b-8ee9-f561b3df1d6a@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/13/20 5:17 PM, Jens Axboe wrote:
> Carter reported an issue where he could produce a stall on ring exit,
> when we're cleaning up requests that match the given file table. For
> this particular test case, a combination of a few things caused the
> issue:
> 
> - The cq ring was overflown
> - The request being canceled was in the overflow list
> 
> The combination of the above means that the cq overflow list holds a
> reference to the request. The request is canceled correctly, but since
> the overflow list holds a reference to it, the final put won't happen.
> Since the final put doesn't happen, the request remains in the inflight.
> Hence we never finish the cancelation flush.
> 
> Fix this by removing requests from the overflow list if we're canceling
> them.

What I queued up was a v2, only difference being that we increment the
overflow counter if we prune it. Below for reference:


commit 2ca10259b4189a433c309054496dd6af1415f992
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Feb 13 17:17:35 2020 -0700

    io_uring: prune request from overflow list on flush
    
    Carter reported an issue where he could produce a stall on ring exit,
    when we're cleaning up requests that match the given file table. For
    this particular test case, a combination of a few things caused the
    issue:
    
    - The cq ring was overflown
    - The request being canceled was in the overflow list
    
    The combination of the above means that the cq overflow list holds a
    reference to the request. The request is canceled correctly, but since
    the overflow list holds a reference to it, the final put won't happen.
    Since the final put doesn't happen, the request remains in the inflight.
    Hence we never finish the cancelation flush.
    
    Fix this by removing requests from the overflow list if we're canceling
    them.
    
    Cc: stable@vger.kernel.org # 5.5
    Reported-by: Carter Li 李通洲 <carter.li@eoitek.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6d4e20d59729..5a826017ebb8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -481,6 +481,7 @@ enum {
 	REQ_F_TIMEOUT_NOSEQ_BIT,
 	REQ_F_COMP_LOCKED_BIT,
 	REQ_F_NEED_CLEANUP_BIT,
+	REQ_F_OVERFLOW_BIT,
 };
 
 enum {
@@ -521,6 +522,8 @@ enum {
 	REQ_F_COMP_LOCKED	= BIT(REQ_F_COMP_LOCKED_BIT),
 	/* needs cleanup */
 	REQ_F_NEED_CLEANUP	= BIT(REQ_F_NEED_CLEANUP_BIT),
+	/* in overflow list */
+	REQ_F_OVERFLOW		= BIT(REQ_F_OVERFLOW_BIT),
 };
 
 /*
@@ -1103,6 +1106,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		req = list_first_entry(&ctx->cq_overflow_list, struct io_kiocb,
 						list);
 		list_move(&req->list, &list);
+		req->flags &= ~REQ_F_OVERFLOW;
 		if (cqe) {
 			WRITE_ONCE(cqe->user_data, req->user_data);
 			WRITE_ONCE(cqe->res, req->result);
@@ -1155,6 +1159,7 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
 			set_bit(0, &ctx->sq_check_overflow);
 			set_bit(0, &ctx->cq_check_overflow);
 		}
+		req->flags |= REQ_F_OVERFLOW;
 		refcount_inc(&req->refs);
 		req->result = res;
 		list_add_tail(&req->list, &ctx->cq_overflow_list);
@@ -6463,6 +6468,29 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 		if (!cancel_req)
 			break;
 
+		if (cancel_req->flags & REQ_F_OVERFLOW) {
+			spin_lock_irq(&ctx->completion_lock);
+			list_del(&cancel_req->list);
+			cancel_req->flags &= ~REQ_F_OVERFLOW;
+			if (list_empty(&ctx->cq_overflow_list)) {
+				clear_bit(0, &ctx->sq_check_overflow);
+				clear_bit(0, &ctx->cq_check_overflow);
+			}
+			spin_unlock_irq(&ctx->completion_lock);
+
+			WRITE_ONCE(ctx->rings->cq_overflow,
+				atomic_inc_return(&ctx->cached_cq_overflow));
+
+			/*
+			 * Put inflight ref and overflow ref. If that's
+			 * all we had, then we're done with this request.
+			 */
+			if (refcount_sub_and_test(2, &cancel_req->refs)) {
+				io_put_req(cancel_req);
+				continue;
+			}
+		}
+
 		io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
 		io_put_req(cancel_req);
 		schedule();

-- 
Jens Axboe

