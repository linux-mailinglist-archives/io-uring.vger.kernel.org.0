Return-Path: <io-uring+bounces-7500-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 434B9A90CD0
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 22:11:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CBB7447D33
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 20:11:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AFA622371A;
	Wed, 16 Apr 2025 20:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZGGFYLuG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D282B226863
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 20:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744834272; cv=none; b=j+yTdrNfUuhkGiKEBwl90ksx6rpPFS5/+FXSCtBRCbzCVi4axD2ggvz9Ec6cYESfkgOc0wdZm7JfG7KOcymJ6OZCtpSVblNp4P/IHCjAZuZ4zIGtuByeuOwyG4HBcenMheS9suaoNe2P4cMzYi5TvxydAXFngYry40uuldK6x8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744834272; c=relaxed/simple;
	bh=l7OY9MTbRmT6DmINjYzD35Z3e0I8QoKZa+gj0ZCtCpc=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=RwIGNNXJ4qTeGuzjCTltS9G7Ju61OqQAOI+DjDRzTcY8PjG4l3NlmfzVe4/W4qJAglSxYchln+Kmq3Nh2zHI9E95T25bZgPwlVgZZ8eYAirViUBzpyxgt/xaqbyDzGc9xbuN37susE2EytCTQm645/12tobn/CELrbp5BNagoAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZGGFYLuG; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3d8092656a9so3618365ab.0
        for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 13:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744834269; x=1745439069; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bINbl9ModA7oPXY0EA9P0WfSExNbaAwylOWoelFG8pk=;
        b=ZGGFYLuGjvFBrrLb6arXKYZtgYvHa+XZ0MFyZe+p7jRbZDLHZ9c3WclxyiDNU4DFbT
         27imurBX4Tg05l+5cAZGcKCvIWd2csfpy9tXXNWlv6u+6wppwfeEhUuxbvcbUq0hgAvG
         3ga4nmK2iqlGrV0+md2OY1tHdHmecftnH3Pyfe+BxyNnQcMMwcBlnLwOT/UYVfARnA77
         knJXu2KlP3AX3EmUCbWPv4mPalEaJgOe2wOT7uYtm5hn3xKxXoX9qJ99q9mE/fKnQpwT
         +Uu3wSwoU+NqmxaIgaZ5Y1CePVlDcHS6efY7shte7tDE6p/5XsUOcvzBgCKUK8yer4lO
         zfxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744834269; x=1745439069;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bINbl9ModA7oPXY0EA9P0WfSExNbaAwylOWoelFG8pk=;
        b=YPMnUHVg7JuyMOwZizWjTXKVuoRih+5iXW9zresoa+efuhLaZdQ4qXvSDJAn5pw1iU
         BHBPprphXb98O0f0j34BVkiDNy+eyAMo1DpP0iScVIMNMJ/pfT8nb2GY73HO5AOzmIAi
         IJsteKhSlwSMo32zIgO3phHWBRW9Uc3Jw0zmXwU4SCvSF5ipEWo1WdkWelmwOXdEhwOE
         asWzB4/01bISAkUmjyNI0sR5Mt0lXif9CihcgYOifn8zrS9wf4TulSX/bi6lYAhTF5ll
         OxMHRBC4EPGn8u/UXu1LgBgbE2uzcRCK+MAi3TXFtUBfXUTYW/wdnWc7JNvYEz/Kv40/
         90hQ==
X-Gm-Message-State: AOJu0Yx4X9ZsufnvL58JC0TbrZP7L4tkkEwvYnyevdXD370eymXNbukV
	Xu7SPP1bmyqIx1I6B28qd8Yf396ddBwyC/a/8PQ/GZi7iDdaXSURz8JtHnbLKyd0yol7q7XJHWB
	t
X-Gm-Gg: ASbGncsUW4XSynQ3XuswDYAL3HqiUuBMwM+dQ/TbefVsu0eyHIa1KSiXfoOvHn3T4Zq
	UPDdcplXPCyTuQ9VIu2LCToJq/83CUdtlG5rbBCAEio43JBeXWTXaJ5azxkuNq+MVzoIAdCBlEB
	I/hh0Ds9DOlNq2VbgG2Ppn4QwWVpWcnQ8H7VyJwf9A4xPSaGO7bA/PzjHnozyv7ZRmaZEZeT0w6
	plQ0m4ZoCn8DAaalxbMTA7RsNiD/p0yt1hFcH4CWBj0RelKRoim/hp9FiqVN1g1rbB4oJ7RnOKH
	KOW1bzpjngIF1HAEIn620p+RjxxC7Hg=
X-Google-Smtp-Source: AGHT+IGAlwXxHwxUNEomtcEHjVW86f1o6DAI9qF+a4+bH+Q0NPxp+pLKY38B57GxjrUfkr0WTmPj7w==
X-Received: by 2002:a05:6e02:18cc:b0:3d4:2acc:81fa with SMTP id e9e14a558f8ab-3d81b660902mr2301305ab.2.1744834269641;
        Wed, 16 Apr 2025 13:11:09 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d7dc592afcsm39702695ab.66.2025.04.16.13.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 13:11:08 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <yq1o6wveuun.fsf@ca-mkp.ca.oracle.com>
References: <yq1o6wveuun.fsf@ca-mkp.ca.oracle.com>
Subject: Re: [PATCH] man: Fix syscall wrappers in example code
Message-Id: <174483426882.431568.3152351618925531263.b4-ty@kernel.dk>
Date: Wed, 16 Apr 2025 14:11:08 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Wed, 16 Apr 2025 16:08:53 -0400, Martin K. Petersen wrote:
> The example code in io_uring.7 provides two wrappers for the io_uring
> syscalls. However, the example fails to take into account that glibc's
> syscall(2) returns -1 and sets errno on failure. This means that any
> errors returned by the provided wrapper functions will be reported as
> -EPERM which could lead to incorrect error handling actions being
> taken.
> 
> [...]

Applied, thanks!

[1/1] man: Fix syscall wrappers in example code
      commit: 4c9be7fdbb83b9e2872721fb026befa052f65ded

Best regards,
-- 
Jens Axboe




