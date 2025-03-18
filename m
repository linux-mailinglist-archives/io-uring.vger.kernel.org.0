Return-Path: <io-uring+bounces-7115-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ADA0A67C8D
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 20:03:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11B2617F836
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 19:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 419091898FB;
	Tue, 18 Mar 2025 19:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dnOXPF8I"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9921AB50D
	for <io-uring@vger.kernel.org>; Tue, 18 Mar 2025 19:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742324579; cv=none; b=l/mKt7r5b3u6f8j6+abfetmY0nQgbAyGjLFXhFKXHMuXKSpkoi5VvKoB+CsPon+YBPx8fWdAp+Om9Nknx4KHVZfTo3IfYEfqfk0+MTHZTPdEfa/Ee6cIs+Mc9KREcw3BZIWO5/sGniVocWBy6ns3n+G+fpncWB3LQXx206WDlIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742324579; c=relaxed/simple;
	bh=j/4gyZBVfmmR66HsKuabHiDNPPajKjCENfTvRkCNEm8=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=XLotHn81gGerxUZGloyEPJ5JM/PyOkENTYwe5pNuQ+s/MaDClQGmqOLDg3lJO8fECfje76wYUvmcTVGdsFBICnNGwIQp/hh540e3n0kLNk8p50T3fVZhEA4mV1FnyLP9lIWRFPrXuB9MQkaiABmiw0g2BV2Y72vMialgTaX7c4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dnOXPF8I; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-85da539030eso206382639f.1
        for <io-uring@vger.kernel.org>; Tue, 18 Mar 2025 12:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742324570; x=1742929370; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PVSvjbHxGYvDHBNYusaSqmqBO7cPdlWCrRmvbNayBng=;
        b=dnOXPF8ItxW3Nkz+k0s9iHbrQR2Wl7BNbzNbJzL3X6g2BeTwRdmviTArf67rjafYjH
         mCOuAu1mMGYsA3vX8Lar9PNTUsohp1wHj7rkFI3KA1gFXkr8gx1FKnchEjgZAvz6AIqR
         eyInJZu9Km+gtl+4mWfywLOX0WHMTq1X1UZ5Y4P5wY+eAoPvj4ghwQh5m00FsZNPtt74
         8C9b8BCrRf3VE8Rkv2m83AvgqnS1NDcmnQ+Rp9Rf1XweXMG7aU2A3FYCx9EDWwaCxJ94
         OuF3xe45Ap+IJ/yRz76KcFmJiWOhGC6HGpMI63W7P/EkSQOYg0yVOWWEw9znRuz9sUhV
         zklA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742324570; x=1742929370;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PVSvjbHxGYvDHBNYusaSqmqBO7cPdlWCrRmvbNayBng=;
        b=i/sS8lx/HjGLTCgjXa3gtG0FxOz+xz+LrZuvLOGKZimDxrD4CR4f3MeUfYYr/cuJfi
         wVb36gS1gQXf2d/onVLNrMpJwmjydGvojErFuBBJTfsXJeZs6GMqRgNNVZ+9gNhbCoIT
         79SS21hIovCO9k8eJxA1jM3TK6GEMRP6SpARFymmIJfqK+XRHwSmwA1royab4UHX3FnW
         GeEwn7UAAXDWpetDZ5twCq9MLoKwuxpAGrepTx9F1+/+domMbjGjuyIbbvfpY4jUoB73
         oiFKf+zIWTIg0KCGycn7dRrKSJLX47ovpmqfUtxO3aoSnHKeVMm3HVG95klTivQcmjt7
         A/kQ==
X-Gm-Message-State: AOJu0YwMq2SRB3HLAJriijU0l3v5xYW4C0lb8TMoybWNeIHfT1fGxTm5
	Y/VVjbunQ0iktHUMccqWid+jrAFpt2teNcPkDO/MEva/411jhVkmG70md/ACTmIf88yhf0ydPjY
	v
X-Gm-Gg: ASbGncub+FzOiVZz7+jkLu98Iqp7TEt4kWDCo9JlKeQ8x42ibZItX1VeY6i+jndp0DP
	sZSwt7DreYS11ZlkyBxyebYbSXCBKq72hmo4Cl1ZT6k7eGZyeB52LlsfbWlpA00S5fr97zVckpM
	ku+aMdubQClVvzAHEccYr6QtYj7zI9mV16V1fvxTVPPoKMjLDljzmIoLgu7sINDsCktLKzvh5z4
	AazAfh3cQp8b5h/gHPg4WtHOYuJxQil2ZEgb3bNOdyheEFVrCbNV+OixH5foUknAocop5J4FN2c
	DrT43NqEpPCloSPvFaCdM5Y53R0FIfNACP3UCXsygg==
X-Google-Smtp-Source: AGHT+IFOdqyiQUgxQkt1zh2vgHFOSY6CR7L9RDLmfWc5IsWUuomj0Z8wySrvSfw8kHj987V/PD0sjg==
X-Received: by 2002:a05:6602:740f:b0:85b:468a:2d0d with SMTP id ca18e2360f4ac-85e007e8699mr498581639f.2.1742324569890;
        Tue, 18 Mar 2025 12:02:49 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f263816d80sm2837667173.124.2025.03.18.12.02.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 12:02:49 -0700 (PDT)
Message-ID: <efee2adb-cee7-4a38-8ced-2b7d76a10d89@kernel.dk>
Date: Tue, 18 Mar 2025 13:02:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v3] io_uring: enable toggle of iowait usage
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

By default, io_uring marks a waiting task as being in iowait, if it's
sleeping waiting on events and there are pending requests. This isn't
necessarily always useful, and may be confusing on non-storage setups
where iowait isn't expected. It can also cause extra power usage, by
preventing the CPU from entering lower sleep states.

Add a sysctl knob to control this, /proc/sys/kernel/io_uring_iowait. It
defaults to '1' which is the current behavior, and can be set to 0 if
iowait accounting and boosting isn't deemed suitable on that system.

Implemented as an int proc variable rather than a bool, in case there's
a need to expand this in the future to distinguish between iowait
accounting and cpufreq boosting. Bool proc entries do allow > 1 values
without erroring, let's retain those for when we may actually use them.

In the future, enter flags may be added to control this as well. For
now, a system-wide knob is enough.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Changes since v2:
- Make it a sysctl knob instead, leaving per-ring enter flags as a
  future kind of thing.

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 58003fa6b327..2866ab55a739 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -156,9 +156,10 @@ static struct workqueue_struct *iou_wq __ro_after_init;
 
 static int __read_mostly sysctl_io_uring_disabled;
 static int __read_mostly sysctl_io_uring_group = -1;
+static int __read_mostly sysctl_io_uring_iowait = 1;
 
 #ifdef CONFIG_SYSCTL
-static const struct ctl_table kernel_io_uring_disabled_table[] = {
+static const struct ctl_table kernel_io_uring_sysctl_table[] = {
 	{
 		.procname	= "io_uring_disabled",
 		.data		= &sysctl_io_uring_disabled,
@@ -175,6 +176,15 @@ static const struct ctl_table kernel_io_uring_disabled_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "io_uring_iowait",
+		.data		= &sysctl_io_uring_iowait,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 };
 #endif
 
@@ -2496,7 +2506,7 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	 * can take into account that the task is waiting for IO - turns out
 	 * to be important for low QD IO.
 	 */
-	if (current_pending_io())
+	if (sysctl_io_uring_iowait && current_pending_io())
 		current->in_iowait = 1;
 	if (iowq->timeout != KTIME_MAX || iowq->min_timeout)
 		ret = io_cqring_schedule_timeout(iowq, ctx->clockid, start_time);
@@ -3959,7 +3969,7 @@ static int __init io_uring_init(void)
 	BUG_ON(!iou_wq);
 
 #ifdef CONFIG_SYSCTL
-	register_sysctl_init("kernel", kernel_io_uring_disabled_table);
+	register_sysctl_init("kernel", kernel_io_uring_sysctl_table);
 #endif
 
 	return 0;

-- 
Jens Axboe


