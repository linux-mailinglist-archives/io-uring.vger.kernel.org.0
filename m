Return-Path: <io-uring+bounces-8769-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F1E8B0DA0F
	for <lists+io-uring@lfdr.de>; Tue, 22 Jul 2025 14:47:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 480D61899AF1
	for <lists+io-uring@lfdr.de>; Tue, 22 Jul 2025 12:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E33D28C2AA;
	Tue, 22 Jul 2025 12:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kp4c0eC7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2C21C07C4
	for <io-uring@vger.kernel.org>; Tue, 22 Jul 2025 12:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753188463; cv=none; b=ViyJiQZywn3G9bIuFByxY0zeX9lV2SZUB1JCD6pXEK5VYpn9wUpv7FRRgvLCFO1MD8RkZVuGoN+LdT/PFTGFmPNMEvYyuatndR6+aUyTrXBGg/NCczDSjJg7WOgPtVE43/Czb+BxDNBz44HaOrWm1Aea3t5L0cOl3Pnk0KLT7q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753188463; c=relaxed/simple;
	bh=BCqqG/JYZREWmqb2TIum+4lHkIqrIqUHj4U48MsJL7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cYV1B/gOCXXWwWl/aWEUQp++4lQF09f3018TolHSPCVL9XWBm2oN6ciExBcmkDHeOdU6eZMq43bPGewa1RAJY225yIzjd3zRE4Iwn+mSImkK/Vgj+duTMWbJTDrWnC38XHt3uadpoAK1x33OfaThj87FJXmqXy5XCT1VeWN94N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kp4c0eC7; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3df210930f7so26136735ab.1
        for <io-uring@vger.kernel.org>; Tue, 22 Jul 2025 05:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1753188460; x=1753793260; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kzA1ZF1lKTa3rq2PsLi0IX0tfwYm6sKML0iO/BSEj7c=;
        b=kp4c0eC7S6H+Ux7Hmq7fgAR0xR45e1VLdFd3BtqPYHAaxsubPZbM7zV7MCrBUgxvt5
         64AqdmOwnVbyl/Aaao0MWQbWZJZHQVu90f7pvWGxJNMPfPp7k0c8KALaTeqPWB7xYW7K
         BtGP+zasZy9NXUIe1x/tUHuDikEOOggsDv9H7Yk/VTboqN1sL7b62dpRQhKnmH2KK+mz
         UrDG/ojJipUlPUPDGU4kq40xVYa/gsUT++tj44vrlezBwautD01bJl+LLFAlsjxLfs9W
         mLylfmmrrveJyfftiTzVc+9PrGj9/v/kOP/rYXpBF5m6K00oXLcKjKNcUvA92/ZhwfrH
         R7gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753188460; x=1753793260;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kzA1ZF1lKTa3rq2PsLi0IX0tfwYm6sKML0iO/BSEj7c=;
        b=oiIJNSqs/I0BC0WeNB1gjQ+jlibFk4Z9EBzJK6BSxjlidSMgdWIFeWLOMY/FimMtlZ
         LWvBpjG2T/dZjTbL+Jx8pLFjb7Fh3wvu3v3Hmmx+gZ9mhijcuH0Hpi/3XmcFsZ0ai1l3
         aidssvo6atMkjkPbdCobUHV7AAxxEEPpqCa0AIz0bl5ISBuEQ+c95iEeBjtqfF2giVbX
         +ayo3c42DeTrZqc+Y+FzFq16Uj23ocHMRKJ4SUDxW3qwVKh9pOExN5qS3umgDLe43Jhl
         Qj2z2KlRqGz5INbz62jRc+N7eOHjjlYRRBHnwDTpzzAgqKEwoP6G7EtR59vlvmG7KPbO
         Up4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWWl5GAySpuGNZ7rMPmytnG6Xe/7gwcQAJy/TcYWNuMZ1pbs0u0gtUEpZ7b6KzwmDMOdsmNtTpIog==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6iS++EFZkjw67H6A6ZpVZc+gDxCJ9X0vcS1JAeQln8033f4nR
	koy7KHILzRiRjQRjvS0RTIirHmA2UJ4jYKHdIRu28+hdRjytxfF06f1oLmtejc/khtc=
X-Gm-Gg: ASbGncuIIwZdsixkmhuravCQl7E+fb0Z7hda3AnIMwLVG3JHoSiC68EhtRZjYHbZ5aF
	UMvc+B0oYbl+zAs9oUQDaQRWsQKFrbgjSWXekCKzwtLCw78Sw2e98OFGKS7wbBKnjaQS4mWUH2q
	z7XOh1DiRxElsbbKmggV0tlX0hEdswEEHz5kWIw/+6xKKAVF3IlhFhvVzJ3R33uYeAvEFSdyb2h
	DNt/m5nrK6xCEEMpQIVhhrZYC3llyQaBIYE2E1i85bTrfiRSDeT/4HHAm4VOX18Yoo0RvqB4pXz
	l+RTh13HQhTHqfOCAntCjVIpb3djMxtL4pqmptpNVCB8eoYa/vDvR0MlggNXiEcYkvgwfB4j4+x
	kOHO6LFlgS81Cp+6V5Y0=
X-Google-Smtp-Source: AGHT+IGDETyK8V2byKtut5obhRIYa3guF+9RXcxMNbbRL1RH+67Jyl+q2Kn1hTA1U7321+G/NVX+Qg==
X-Received: by 2002:a05:6e02:1fcb:b0:3dc:7b3d:6a45 with SMTP id e9e14a558f8ab-3e2be594312mr53708305ab.0.1753188460499;
        Tue, 22 Jul 2025 05:47:40 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e29826d45esm31215735ab.36.2025.07.22.05.47.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 05:47:40 -0700 (PDT)
Message-ID: <cf0447d1-3590-4540-932d-4be299edc432@kernel.dk>
Date: Tue, 22 Jul 2025 06:47:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KASAN: slab-use-after-free Read in
 io_poll_remove_entries
To: syzbot <syzbot+01523a0ae5600aef5895@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <687bd5fe.a70a0220.693ce.0091.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <687bd5fe.a70a0220.693ce.0091.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

diff --git a/drivers/comedi/comedi_fops.c b/drivers/comedi/comedi_fops.c
index c83fd14dd7ad..58b034e45283 100644
--- a/drivers/comedi/comedi_fops.c
+++ b/drivers/comedi/comedi_fops.c
@@ -782,24 +782,33 @@ void comedi_device_cancel_all(struct comedi_device *dev)
 	}
 }
 
-static int is_device_busy(struct comedi_device *dev)
+static int start_detach(struct comedi_device *dev)
 {
 	struct comedi_subdevice *s;
-	int i;
+	int i, is_busy = 0;
 
 	lockdep_assert_held(&dev->mutex);
+	lockdep_assert_held(&dev->attach_lock);
 	if (!dev->attached)
 		return 0;
 
 	for (i = 0; i < dev->n_subdevices; i++) {
 		s = &dev->subdevices[i];
-		if (s->busy)
-			return 1;
-		if (s->async && comedi_buf_is_mmapped(s))
-			return 1;
+		if (s->busy) {
+			is_busy = 1;
+			break;
+		}
+		if (!s->async)
+			continue;
+		if (comedi_buf_is_mmapped(s) ||
+		    wq_has_sleeper(&s->async->wait_head)) {
+			is_busy = 1;
+			break;
+		}
 	}
-
-	return 0;
+	if (!is_busy)
+		dev->detaching = 1;
+	return is_busy;
 }
 
 /*
@@ -825,8 +834,13 @@ static int do_devconfig_ioctl(struct comedi_device *dev,
 		return -EPERM;
 
 	if (!arg) {
-		if (is_device_busy(dev))
+		/* prevent new polls */
+		down_write(&dev->attach_lock);
+		if (start_detach(dev)) {
+			up_write(&dev->attach_lock);
 			return -EBUSY;
+		}
+		up_write(&dev->attach_lock);
 		if (dev->attached) {
 			struct module *driver_module = dev->driver->module;
 
@@ -2479,7 +2493,7 @@ static __poll_t comedi_poll(struct file *file, poll_table *wait)
 
 	down_read(&dev->attach_lock);
 
-	if (!dev->attached) {
+	if (!dev->attached || dev->detaching) {
 		dev_dbg(dev->class_dev, "no driver attached\n");
 		goto done;
 	}
diff --git a/include/linux/comedi/comedidev.h b/include/linux/comedi/comedidev.h
index 4cb0400ad616..b2bec668785f 100644
--- a/include/linux/comedi/comedidev.h
+++ b/include/linux/comedi/comedidev.h
@@ -545,6 +545,7 @@ struct comedi_device {
 	const char *board_name;
 	const void *board_ptr;
 	unsigned int attached:1;
+	unsigned int detaching:1;
 	unsigned int ioenabled:1;
 	spinlock_t spinlock;	/* generic spin-lock for low-level driver */
 	struct mutex mutex;	/* generic mutex for COMEDI core */

-- 
Jens Axboe

