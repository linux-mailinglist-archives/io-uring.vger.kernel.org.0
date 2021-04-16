Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF33362076
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 15:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239124AbhDPNE2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Apr 2021 09:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234291AbhDPNE1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Apr 2021 09:04:27 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615D0C061574
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 06:04:03 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id e8-20020a17090a7288b029014e51f5a6baso9325492pjg.2
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 06:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S3/IqSe2iQQV5Lq0Sn+HG/eLxgX76zBzCLRht01ibzY=;
        b=fKFTuN4VyznKKVpeE44zL40qOobTZ+NB8ZvHXcW6ucXCbQ9myVJKmU9pH/mbvib3Lg
         GoUsOAgzkUkQsZpuxv2MG7CCWuS4t9v/V10Ar/yyOoLV9TJ+NFUAvLp5JT7gRrJ3FAoo
         PvTuc9hKD/R+ZGG0UuK0CAqDtw+xdaGeLHXECwBV5GgM/gfY9UKUzOk0ZbDEmYaTczSx
         ZjWvioIGnRKbrMg+nEr90qnFOPPagcfxQ/dAIQbwAeY5NRs9I5hjRNrDqfqNdyim08WX
         Ax1BLCZwhs4NLCWULw5kclUvi1SfB2WP3FcWVAi3FrpQdwSZ3FCVc4/vOUQ5XLLlP5uH
         hjEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S3/IqSe2iQQV5Lq0Sn+HG/eLxgX76zBzCLRht01ibzY=;
        b=ojgAlfVvRMmKiT68fkWso7MH71vr6NT0frZ1W9z0WpNeJEBFkBCeI09CTTQaCVXors
         v120O+NX8hlCJrsVmjNIM0FJ0gL5/1CmiKlCH6Fw0JF6Xr9uNXArzX3jmF3J6hxS17PB
         AUXhciMicf3ykb1hHXRJe2CCuiTMHuUsq+reYobShcH3paMRF+srYtfxRAS9SZh2rTEm
         QverAQDlpdyG9ZYHegVjZCLlBl4FmILDfY0u7ll7DYW8tUvxW4DylPxyIzledDz3dc0A
         ivo2u7s1zudWxune1yXbLObxcgsVu6w2szyOfT0aT/kWX2vH01pWOiYxDUwLpv/rAYT7
         Al9Q==
X-Gm-Message-State: AOAM531t5Uc9eSZVKxJXVi4YZTRpsytxJMnlSx7Y+Ob+L1pDdJ5ID3Ay
        nV/ABDbdQzW/uMDRwaId1yvRbw==
X-Google-Smtp-Source: ABdhPJz/N7qLqxpe+r1Z5dmPVsc6ymxgg2T0SzWLtgsha6q16saLuT2n7CmpJs3ZxMazvcq5FKY2oA==
X-Received: by 2002:a17:90a:ba05:: with SMTP id s5mr9858955pjr.194.1618578242793;
        Fri, 16 Apr 2021 06:04:02 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z23sm5094906pgj.56.2021.04.16.06.04.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 06:04:02 -0700 (PDT)
Subject: Re: [PATCH 0/2] fix hangs with shared sqpoll
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>, Joakim Hassila <joj@mac.com>
References: <cover.1618532491.git.asml.silence@gmail.com>
 <8d04fa58-d8d0-8760-a6aa-d2bd6d66d09d@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <36df5986-0716-b7e7-3dac-261a483d074a@kernel.dk>
Date:   Fri, 16 Apr 2021 07:04:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8d04fa58-d8d0-8760-a6aa-d2bd6d66d09d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/15/21 6:26 PM, Pavel Begunkov wrote:
> On 16/04/2021 01:22, Pavel Begunkov wrote:
>> Late catched 5.12 bug with nasty hangs. Thanks Jens for a reproducer.
> 
> 1/2 is basically a rip off of one of old Jens' patches, but can't
> find it anywhere. If you still have it, especially if it was
> reviewed/etc., may make sense to go with it instead

I wonder if we can do something like the below instead - we don't
care about a particularly stable count in terms of wakeup
reliance, and it'd save a nasty sync atomic switch.

Totally untested...


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6c182a3a221b..9edbcf01ea49 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8928,7 +8928,7 @@ static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx)
 	atomic_inc(&tctx->in_idle);
 	do {
 		/* read completions before cancelations */
-		inflight = tctx_inflight(tctx, false);
+		inflight = percpu_ref_sum(&ctx->refs);
 		if (!inflight)
 			break;
 		io_uring_try_cancel_requests(ctx, current, NULL);
@@ -8939,7 +8939,7 @@ static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx)
 		 * avoids a race where a completion comes in before we did
 		 * prepare_to_wait().
 		 */
-		if (inflight == tctx_inflight(tctx, false))
+		if (inflight == percpu_ref_sum(&ctx->refs))
 			schedule();
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 16c35a728b4c..2f29f34bc993 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -131,6 +131,7 @@ void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 void percpu_ref_resurrect(struct percpu_ref *ref);
 void percpu_ref_reinit(struct percpu_ref *ref);
 bool percpu_ref_is_zero(struct percpu_ref *ref);
+long percpu_ref_sum(struct percpu_ref *ref);
 
 /**
  * percpu_ref_kill - drop the initial ref
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index a1071cdefb5a..b09ed9fdd32d 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -475,3 +475,31 @@ void percpu_ref_resurrect(struct percpu_ref *ref)
 	spin_unlock_irqrestore(&percpu_ref_switch_lock, flags);
 }
 EXPORT_SYMBOL_GPL(percpu_ref_resurrect);
+
+/**
+ * percpu_ref_sum - return approximate ref counts
+ * @ref: perpcu_ref to sum
+ *
+ * Note that this should only really be used to compare refs, as by the
+ * very nature of percpu references, the value may be stale even before it
+ * has been returned.
+ */
+long percpu_ref_sum(struct percpu_ref *ref)
+{
+	unsigned long __percpu *percpu_count;
+	long ret;
+
+	rcu_read_lock();
+	if (__ref_is_percpu(ref, &percpu_count)) {
+		ret = atomic_long_read(&ref->data->count);
+	} else {
+		int cpu;
+
+		ret = 0;
+		for_each_possible_cpu(cpu)
+			ret += *per_cpu_ptr(percpu_count, cpu);
+	}
+	rcu_read_unlock();
+
+	return ret;
+}

-- 
Jens Axboe

