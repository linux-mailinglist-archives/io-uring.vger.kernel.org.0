Return-Path: <io-uring+bounces-3923-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E1349AB7F1
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 22:47:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8695AB2369A
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 20:47:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F27B1CCB4D;
	Tue, 22 Oct 2024 20:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Df2UuwOk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8127F1C9ED6
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 20:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729630037; cv=none; b=e7pLYryV8p6lP08ljJJkXosrwOlC4dnOHjzNHwumc3VK9l/jXTsmtG5u0fykyMtq3hb3opgGY0IBX21kZrkF0WXQ/TjEPuS0fg9SQh/9twMP3z/7GPCji62jJ7eHIxSMshSGiGL92EcPACGU/X2BSfWoxa+vbAgsRZxvBVdd+ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729630037; c=relaxed/simple;
	bh=cdnQ0JeTuMHSQ+lYX+/+93+yzocC6/i2o3K2TVD8Xvc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ICmZkFRLmDtIeoPd2wnfag23TiddBsQx46wLYZEqFRWFNpePr4+DNHdtyWEcdDO6CIcXVqBXp3rYSvVyhBKVvHD/g3hmr4KjAWs84uRkbNLmdu1eYC0WXpEDRXKnuS6tFo3j051b0H39IgQ6a9q9BbWf2T2R7Hx4hOqH6tt7oJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Df2UuwOk; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3a3f82b2018so14416205ab.0
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 13:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729630032; x=1730234832; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=TqgFQaGP5WKq0MdEL7bb+fJtpTRsHYvDC9CKdv+P6qE=;
        b=Df2UuwOkoE4WZcXhOfDqnsvBOlWk8DFMsVVFkwmvtobMUBKVc60OV83hEvLQOffI0l
         rovXu3KJOqY3u4CkqmPHPbwj9Z5pIZYPyf35xVL3MMso7eqaIpuipFZAYidWLWbedUGH
         ZgEP3p2BOKHOJx9a6RAja2pb+CuKNayxzXU16LpiQzWq8ZWiD87XIvThu7clGwtB/TTU
         7Eqam+KMjLsiRikRnTQItrf7rqA+cQU+YMBEjSoKqDvvkaGLteM//z4rnZn4sskrpFIv
         A8WgrxHzapneWPZ0maUcALGtmKLkx48ZfJJU6PvUa/s1KT0As7IqQg0cQWkLMxFOggnC
         4now==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729630032; x=1730234832;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TqgFQaGP5WKq0MdEL7bb+fJtpTRsHYvDC9CKdv+P6qE=;
        b=pi8Ihbzeeb8vwJB61UNKPByibNSoR3psspRuNNMhref6g1iNpRbvituySAMNBtgn6p
         Zn2yFBs4AvPNF6TXQp4rAEzNF/8DnVBpjkkQmOs4+cpHaJePy7sIKQoU5bu8XtWaaz4q
         6+jviS8hFUosPADJEO/NcvE52RtWOFM+Gli7R18HyrHmZ7aWDVXlxo+P6ZJplwMUdPuk
         uALZaDvSUZN00AuyanzIVLclvYJ3xhmCtbNIoXbICKzUuoV3eyYiBTBYv2q1EGce+7IA
         +mwE6oadDkmxnczZGEkT+iUW57jLHjKUrs/1NzeB/uN58Sq+tg7BRL1gqCKZX9S8zuvz
         yqLw==
X-Gm-Message-State: AOJu0YzqUQiocxRqy4hR8wtCctybytRM4pIJaN1kac65Y07mG5f5xQ3k
	Zp3wrtOYFDNuebqAIYDAg6ReKq+MGY81wzKomYsd3gR9RAY9lP6054+q/ogdbiMsC67sZP6zqZz
	M
X-Google-Smtp-Source: AGHT+IHmw4Mznoc7iFUoTWr05tM7t8FRlIM1VX9IfuvvGFArVmN4sxMenzr8oKYzeg+Ey740ixbydg==
X-Received: by 2002:a05:6e02:1649:b0:3a3:97b6:74fe with SMTP id e9e14a558f8ab-3a4d597b734mr4400975ab.11.1729630031747;
        Tue, 22 Oct 2024 13:47:11 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a5571d1sm1697385173.52.2024.10.22.13.47.11
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 13:47:11 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET RFC 0/3] Add support for registered waits
Date: Tue, 22 Oct 2024 14:39:01 -0600
Message-ID: <20241022204708.1025470-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

While doing testing on zero-copy tx/rx with io_uring, I noticed that a
LOT of time is being spent copying in data structures related to waiting
on events. While the structures aren't big (24b and 16b), it's a user
copy, and a dependent user copy on top of that - first get the main
struct io_uring_getevents_arg, and then copy in the timeout from that.
Details are in patch 3 on the numbers.

I then toyed around with the idea of having registered regions of wait
data. This can be set by the application, and then directly seen by the
kernel. On top of that, embed the timeout itself in this region, rather
than it being supplied as an out-of-band pointer.

Patch 1 is just a generic cleanup, and patch 2 improves the copying a
both. Both of these can stand alone. Patch 3 implements the meat of this,
which adds IORING_REGISTER_CQWAIT_REG, allowing an application to
register a number of struct io_uring_reg_wait regions that it can index
for wait scenarios. The kernel always registers a full page, so on 4k
page size archs, 64 regions are available by default. Then rather than
pass in a pointer to a struct io_uring_getevents_arg, an index is passed
instead, telling the kernel which registered wait region should be used
for this wait.

This basically removes all of the copying seen, which was anywhere from
3.5-4.5% of the time, when doing high frequency operations where
the number of wait invocations can be quite high.

Patches sit on top of the io_uring-ring-resize branch, as both end up
adding register opcodes.

Kernel branch here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-reg-wait

and liburing (pretty basic right now) branch here:

https://git.kernel.dk/cgit/liburing/log/?h=reg-wait

 include/linux/io_uring_types.h |   7 +++
 include/uapi/linux/io_uring.h  |  18 ++++++
 io_uring/io_uring.c            | 102 ++++++++++++++++++++++++++-------
 io_uring/register.c            |  48 ++++++++++++++++
 4 files changed, 153 insertions(+), 22 deletions(-)

-- 
Jens Axboe


