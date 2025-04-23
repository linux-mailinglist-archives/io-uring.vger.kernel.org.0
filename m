Return-Path: <io-uring+bounces-7669-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94616A993DB
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 18:04:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8CC77AAEAB
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 16:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7AD329DB75;
	Wed, 23 Apr 2025 15:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="R8RZ99kq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEEC296147
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 15:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745423710; cv=none; b=KCmq7ifnKoI+RAZWl3Be+S6YBtaIurjzXjqHKR6hY9Kcc6hfILdfTYJ3C74HJNGKchncVRALsouKCLU5f56YO3fAdrxGqicBz1F3X8DoYVFXaoPgCrLAciduDZx33uUfSb+hTllZ4MQr79qXaVnlSWXrLut3uERV8H0t/76/GbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745423710; c=relaxed/simple;
	bh=6bxam3x3p1jkVVS+mqQyKWW0nqRcxA/31AUdC8hZTIM=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:From:To:Cc:
	 References:In-Reply-To; b=ZFPfU8Jfmmtd4WuRDc7mAxNncIPOLzpIstFjX9mZdnwAzmUigpynzdJVEqiyqk9gKcbjhm85nmG7ZjTv7kDdkjcsuGakG6z2cILbQ7BPsXs8MqmuqH4b9wqfhnxmyg5m0TY4Ur9WiHz+VLfeq6VJOu3VpnrRp6jiYS9JqM+p0Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=R8RZ99kq; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-8613f456960so1920539f.1
        for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 08:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745423706; x=1746028506; darn=vger.kernel.org;
        h=in-reply-to:content-language:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZtSbdG0Ykh7QLewJcbTObDa0V9VkFDhfWB0FOIHbABA=;
        b=R8RZ99kqBIWyCy9HfY+GvlRzqkQSo7X0gYfBK+2ov1Z5FLdDkhuMFn2p92+PtRw7ZY
         Mhcy2zREFbuDKIvMIkDASqZSOnInank5gZL1rYNkUHzckndwpjMBA30VCGWlQuwx2iY8
         6TJjE96TcqYjq3pdDGrHjmkMNtA31yIyIIiRmA8ejXqHCsehfxyFVRiMd+yapZLRirSv
         39es4b4GEGNAtyeZRaVXrcN+83LmaBzk3MER6xToxs7PkUAITznK8jzwy6WdPQ9ZbMCW
         /Jq4DGVbWez2qiD49efB0vZUQV6M8nHydh9oNYschU710HKQCcAQi6QSf3gEXb3F+6N2
         Pggg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745423706; x=1746028506;
        h=in-reply-to:content-language:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZtSbdG0Ykh7QLewJcbTObDa0V9VkFDhfWB0FOIHbABA=;
        b=peD4Y7qAAtYyAyMDt3dKqtPywYH5AE4AC4JmJc4S5EPOGiscUk1zDbFNa1zwTJ/Ck1
         JM4KP8Fh9DVTDuZuBApnK3nsuch7k1BjOSY2fulG6PgUjRqyHjBKnMa+f5YChsZek79B
         EjHbYdNjUKOYT4ADFtQKAq5f4Ch314ZnwQKvHhOIDA0sHIQhbjorl0krCxFu3bMqLBsb
         gY45m4Uo0z5bGY0HZNS5AtjiSMKzZ8Za5aC/ZhmQCmakINXOSa5RMxZ+u+2Aiy8yLd59
         P4JGSFAFvQ9Dnz1+QV4ikLM0Ol0DOc2SNxTZ9uJyCSBzOMcWBkK4p9xvto2PC1hRYqq+
         oiUg==
X-Forwarded-Encrypted: i=1; AJvYcCUbGIX7g2NvHudgPTxZ3WzVeRiSiChQIFeKr6wJ01omVMU5zNmayqnJ7QqKaKs4G3nkzhOknR8kuQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzVLCYGMPkZ+Kd9jquSZnThEYJ4o9W+gfHKiBZov9h7uFTWIWhL
	cwN6+XpxKYKl8d9Hm05koSUmFKABq2EUJ9bfDyAfgclCKvLMQs3fUk0atm6WYS4=
X-Gm-Gg: ASbGnctD0K5myZPbCa2v/svgSnsiGYui3CjB07jr7QhE7jyS2oBfaHspAjEUnzWRejl
	yFBCsAJDpn7jkpCfae8pXyX4HT6XykExInFjAtZSr9kQ965+dXnmweTE7fkc6ziCaQwNMCnv0Oo
	cV9y6ZMDImTacRa5o3iO7LuSh1XOP0FAM7153EgtzkmVvJf+BpHhpGDt6FMqbVDxBCqrImWJjCA
	4fb0yQ3EXDNQ6RdxUqS922qCwM488ITgOVJiSsMn9lNwfSBO3UYEntDjaf+lwotKiBA6oSKMYLa
	g+UOs8pDWOJoGsVIl46P2mxSYgnNShiZT/mM
X-Google-Smtp-Source: AGHT+IHqWBSyOZ3W+taQCgreEn0bCABTE56K1B+4Rd2BDzJ88iYkPnEO6/sAZqffRC7L5Ka+dipuJA==
X-Received: by 2002:a05:6e02:2586:b0:3d3:fbf9:194b with SMTP id e9e14a558f8ab-3d889047e24mr175224285ab.0.1745423706226;
        Wed, 23 Apr 2025 08:55:06 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d927695877sm4059385ab.53.2025.04.23.08.55.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 08:55:05 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------q5NDZdvobEhcchbgiQ1tLFB4"
Message-ID: <52d55891-36e3-43e7-9726-a2cd113f5327@kernel.dk>
Date: Wed, 23 Apr 2025 09:55:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] io_uring: Add new functions to handle user fault
 scenarios
From: Jens Axboe <axboe@kernel.dk>
To: =?UTF-8?B?5aec5pm65Lyf?= <qq282012236@gmail.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 akpm@linux-foundation.org, peterx@redhat.com, asml.silence@gmail.com,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20250422162913.1242057-1-qq282012236@gmail.com>
 <20250422162913.1242057-2-qq282012236@gmail.com>
 <14195206-47b1-4483-996d-3315aa7c33aa@kernel.dk>
 <CANHzP_uW4+-M1yTg-GPdPzYWAmvqP5vh6+s1uBhrMZ3eBusLug@mail.gmail.com>
 <b61ac651-fafe-449a-82ed-7239123844e1@kernel.dk>
 <CANHzP_tLV29_uk2gcRAjT9sJNVPH3rMyVuQP07q+c_TWWgsfDg@mail.gmail.com>
 <7bea9c74-7551-4312-bece-86c4ad5c982f@kernel.dk>
Content-Language: en-US
In-Reply-To: <7bea9c74-7551-4312-bece-86c4ad5c982f@kernel.dk>

This is a multi-part message in MIME format.
--------------q5NDZdvobEhcchbgiQ1tLFB4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Something like this, perhaps - it'll ensure that io-wq workers get a
chance to flush out pending work, which should prevent the looping. I've
attached a basic test case. It'll issue a write that will fault, and
then try and cancel that as a way to trigger the TIF_NOTIFY_SIGNAL based
looping.

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index d80f94346199..e18926dbf20a 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -32,6 +32,7 @@
 #include <linux/swapops.h>
 #include <linux/miscdevice.h>
 #include <linux/uio.h>
+#include <linux/io_uring.h>
 
 static int sysctl_unprivileged_userfaultfd __read_mostly;
 
@@ -376,6 +377,8 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 	 */
 	if (current->flags & (PF_EXITING|PF_DUMPCORE))
 		goto out;
+	else if (current->flags & PF_IO_WORKER)
+		io_worker_fault();
 
 	assert_fault_locked(vmf);
 
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 85fe4e6b275c..d93dd7402a28 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -28,6 +28,7 @@ static inline void io_uring_free(struct task_struct *tsk)
 	if (tsk->io_uring)
 		__io_uring_free(tsk);
 }
+void io_worker_fault(void);
 #else
 static inline void io_uring_task_cancel(void)
 {
@@ -46,6 +47,9 @@ static inline bool io_is_uring_fops(struct file *file)
 {
 	return false;
 }
+static inline void io_worker_fault(void)
+{
+}
 #endif
 
 #endif
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index d52069b1177b..f74bea028ec7 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1438,3 +1438,13 @@ static __init int io_wq_init(void)
 	return 0;
 }
 subsys_initcall(io_wq_init);
+
+void io_worker_fault(void)
+{
+	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
+		clear_notify_signal();
+	if (test_thread_flag(TIF_NOTIFY_RESUME))
+		resume_user_mode_work(NULL);
+	if (task_work_pending(current))
+		task_work_run();
+}

-- 
Jens Axboe
--------------q5NDZdvobEhcchbgiQ1tLFB4
Content-Type: text/x-csrc; charset=UTF-8; name="ufd.c"
Content-Disposition: attachment; filename="ufd.c"
Content-Transfer-Encoding: base64

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHVuaXN0
ZC5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxwb2xsLmg+CiNpbmNsdWRlIDxz
eXMvbW1hbi5oPgojaW5jbHVkZSA8c3lzL2lvY3RsLmg+CiNpbmNsdWRlIDxsaW51eC9tbWFu
Lmg+CiNpbmNsdWRlIDxzeXMvdWlvLmg+CiNpbmNsdWRlIDxsaWJ1cmluZy5oPgojaW5jbHVk
ZSA8cHRocmVhZC5oPgojaW5jbHVkZSA8bGludXgvdXNlcmZhdWx0ZmQuaD4KCiNkZWZpbmUg
SFBfU0laRQkJKDIgKiAxMDI0ICogMTAyNFVMTCkKI2RlZmluZSBOUl9IVUdFUEFHRVMJKDMw
MDApCgojaWZuZGVmIE5SX3VzZXJmYXVsdGZkCiNkZWZpbmUgTlJfdXNlcmZhdWx0ZmQJMjgy
CiNlbmRpZgoKc3RydWN0IHRocmVhZF9kYXRhIHsKCXB0aHJlYWRfdCB0aHJlYWQ7CglwdGhy
ZWFkX2JhcnJpZXJfdCBiYXJyaWVyOwoJaW50IHVmZmQ7Cn07CgpzdGF0aWMgdm9pZCAqZmF1
bHRfaGFuZGxlcih2b2lkICpkYXRhKQp7CglzdHJ1Y3QgdGhyZWFkX2RhdGEgKnRkID0gZGF0
YTsKCXN0cnVjdCB1ZmZkX21zZyBtc2c7CglzdHJ1Y3QgcG9sbGZkIHBmZDsKCWludCByZXQs
IG5yZWFkeTsKCglwdGhyZWFkX2JhcnJpZXJfd2FpdCgmdGQtPmJhcnJpZXIpOwoKCWRvIHsK
CQlwZmQuZmQgPSB0ZC0+dWZmZDsKCQlwZmQuZXZlbnRzID0gUE9MTElOOwoJCW5yZWFkeSA9
IHBvbGwoJnBmZCwgMSwgLTEpOwoJCWlmIChucmVhZHkgPCAwKSB7CgkJCXBlcnJvcigicG9s
bCIpOwoJCQlleGl0KDEpOwoJCX0KCgkJcmV0ID0gcmVhZCh0ZC0+dWZmZCwgJm1zZywgc2l6
ZW9mKG1zZykpOwoJCWlmIChyZXQgPCAwKSB7CgkJCWlmIChlcnJubyA9PSBFQUdBSU4pCgkJ
CQljb250aW51ZTsKCQkJcGVycm9yKCJyZWFkIik7CgkJCWV4aXQoMSk7CgkJfQoKCQlpZiAo
bXNnLmV2ZW50ICE9IFVGRkRfRVZFTlRfUEFHRUZBVUxUKSB7CgkJCXByaW50ZigidW5zcGVj
dGVkIGV2ZW50OiAleFxuIiwgbXNnLmV2ZW50KTsKCQkJZXhpdCgxKTsKCQl9CgoJCXByaW50
ZigiUGFnZSBmYXVsdFxuIik7CgkJcHJpbnRmKCJmbGFncyA9ICVseDsgIiwgKGxvbmcpIG1z
Zy5hcmcucGFnZWZhdWx0LmZsYWdzKTsKCQlwcmludGYoImFkZHJlc3MgPSAlbHhcbiIsIChs
b25nKW1zZy5hcmcucGFnZWZhdWx0LmFkZHJlc3MpOwoJfSB3aGlsZSAoMSk7CgoJcmV0dXJu
IE5VTEw7Cn0KCnN0YXRpYyB2b2lkIGRvX2lvKHN0cnVjdCBpb191cmluZyAqcmluZywgdm9p
ZCAqYnVmLCBzaXplX3QgbGVuKQp7CglzdHJ1Y3QgaW9fdXJpbmdfc3FlICpzcWU7CglzdHJ1
Y3QgaW9fdXJpbmdfY3FlICpjcWU7CglpbnQgZmQsIHJldCwgaTsKCglmZCA9IG9wZW4oIi9k
ZXYvbnZtZTBuMSIsIE9fUkRXUik7CglpZiAoZmQgPCAwKSB7CgkJcGVycm9yKCJvcGVuIGNy
ZWF0ZSIpOwoJCXJldHVybjsKCX0KCgkvKiBpc3N1ZSBmYXVsdGluZyB3cml0ZSAqLwoJc3Fl
ID0gaW9fdXJpbmdfZ2V0X3NxZShyaW5nKTsKCWlvX3VyaW5nX3ByZXBfd3JpdGUoc3FlLCBm
ZCwgYnVmLCBsZW4sIDApOwoJc3FlLT51c2VyX2RhdGEgPSAxOwoJaW9fdXJpbmdfc3VibWl0
KHJpbmcpOwoKCXByaW50ZigiYmxvY2tpbmcgaXNzdWVkXG4iKTsKCXNsZWVwKDEpOwoKCS8q
IGNhbmNlbCBhYm92ZSB3cml0ZSAqLwoJc3FlID0gaW9fdXJpbmdfZ2V0X3NxZShyaW5nKTsK
CWlvX3VyaW5nX3ByZXBfY2FuY2VsNjQoc3FlLCAxLCBJT1JJTkdfQVNZTkNfQ0FOQ0VMX1VT
RVJEQVRBKTsKCXNxZS0+dXNlcl9kYXRhID0gMjsKCWlvX3VyaW5nX3N1Ym1pdChyaW5nKTsK
CglwcmludGYoImNhbmNlbCBpc3N1ZWRcbiIpOwoJc2xlZXAoMSk7CgoJZm9yIChpID0gMDsg
aSA8IDI7IGkrKykgewphZ2FpbjoKCQlyZXQgPSBpb191cmluZ193YWl0X2NxZShyaW5nLCAm
Y3FlKTsKCQlpZiAocmV0IDwgMCkgewoJCQlwcmludGYoIndhaXQ6ICVkXG4iLCByZXQpOwoJ
CQlpZiAocmV0ID09IC1FSU5UUikKCQkJCWdvdG8gYWdhaW47CgkJCWJyZWFrOwoJCX0KCQlw
cmludGYoImdvdCByZXMgJWQsICVsZFxuIiwgY3FlLT5yZXMsIChsb25nKSBjcWUtPnVzZXJf
ZGF0YSk7CgkJaW9fdXJpbmdfY3FlX3NlZW4ocmluZywgY3FlKTsKCX0KfQoKc3RhdGljIHZv
aWQgc2lnX3VzcjEoaW50IHNpZykKewoJcHJpbnRmKCJnb3QgVVNSMVxuIik7Cn0KCnN0YXRp
YyBpbnQgdGVzdCh2b2lkKQp7CglzdHJ1Y3QgdWZmZGlvX2FwaSBhcGkgPSB7IH07CglzdHJ1
Y3QgdWZmZGlvX3JlZ2lzdGVyIHJlZyA9IHsgfTsKCXN0cnVjdCBpb191cmluZyByaW5nOwoJ
c3RydWN0IHNpZ2FjdGlvbiBhY3QgPSB7IH07CglzdHJ1Y3QgdGhyZWFkX2RhdGEgdGQgPSB7
IH07Cgl2b2lkICpidWY7CgoJYWN0LnNhX2hhbmRsZXIgPSBzaWdfdXNyMTsKCXNpZ2FjdGlv
bihTSUdVU1IxLCAmYWN0LCBOVUxMKTsKCglpb191cmluZ19xdWV1ZV9pbml0KDQsICZyaW5n
LCAwKTsKCglidWYgPSBtbWFwKE5VTEwsIEhQX1NJWkUsIFBST1RfUkVBRHxQUk9UX1dSSVRF
LAoJCQlNQVBfUFJJVkFURSB8IE1BUF9IVUdFVExCIHwgTUFQX0hVR0VfMk1CIHwgTUFQX0FO
T05ZTU9VUywKCQkJLTEsIDApOwoJaWYgKGJ1ZiA9PSBNQVBfRkFJTEVEKSB7CgkJcGVycm9y
KCJtbWFwIik7CgkJcmV0dXJuIDE7Cgl9CglwcmludGYoImdvdCBidWYgJXBcbiIsIGJ1Zik7
CgoJdGQudWZmZCA9IHN5c2NhbGwoTlJfdXNlcmZhdWx0ZmQsIE9fQ0xPRVhFQyB8IE9fTk9O
QkxPQ0spOwoJaWYgKHRkLnVmZmQgPCAwKSB7CgkJcGVycm9yKCJ1c2VyZmF1bHRmZCIpOwoJ
CXJldHVybiAxOwoJfQoKCWFwaS5hcGkgPSBVRkZEX0FQSTsKCWlmIChpb2N0bCh0ZC51ZmZk
LCBVRkZESU9fQVBJLCAmYXBpKSA8IDApIHsKCQlwZXJyb3IoImlvY3RsIFVGRkRJT19BUEki
KTsKCQlyZXR1cm4gMTsKCX0KCglyZWcucmFuZ2Uuc3RhcnQgPSAodW5zaWduZWQgbG9uZykg
YnVmOwoJcmVnLnJhbmdlLmxlbiA9IEhQX1NJWkU7CglyZWcubW9kZSA9IFVGRkRJT19SRUdJ
U1RFUl9NT0RFX01JU1NJTkc7CglpZiAoaW9jdGwodGQudWZmZCwgVUZGRElPX1JFR0lTVEVS
LCAmcmVnKSA8IDApIHsKCQlwZXJyb3IoImlvY3RsIFVGRkRJT19SRUdJU1RFUiIpOwoJCXJl
dHVybiAxOwoJfQoKCXB0aHJlYWRfYmFycmllcl9pbml0KCZ0ZC5iYXJyaWVyLCBOVUxMLCAy
KTsKCXB0aHJlYWRfY3JlYXRlKCZ0ZC50aHJlYWQsIE5VTEwsIGZhdWx0X2hhbmRsZXIsICZ0
ZCk7CgoJcHRocmVhZF9iYXJyaWVyX3dhaXQoJnRkLmJhcnJpZXIpOwoKCWRvX2lvKCZyaW5n
LCBidWYsIEhQX1NJWkUpOwoJcmV0dXJuIDA7Cn0KCmludCBtYWluKGludCBhcmdjLCBjaGFy
ICphcmd2W10pCnsKCXJldHVybiB0ZXN0KCk7Cn0K

--------------q5NDZdvobEhcchbgiQ1tLFB4--

