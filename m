Return-Path: <io-uring+bounces-7861-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 27DF4AAC6E5
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 15:49:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D6731C00DD8
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 13:49:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A69C9280307;
	Tue,  6 May 2025 13:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AXjUEl4U"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233E2281378
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 13:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746539315; cv=none; b=ffrtgZweuy73Hr9Vn+fnzHUWyTUtul4QH+5QuGnhY+vu2aKH9xNRgvgIaEZVH8042xOTv/ysfi6PGl8BLK2lKgP4+HzQs2HPREnRoPPFLl2n2/5hM7xotd0Rhwq9HVoRPHkyu1L8UKcz85X0hf3XE+6aKx6MQf1VS+MKa0IyYLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746539315; c=relaxed/simple;
	bh=uit+ZtF1daVgMJNOqnry+hjMkQsyu2Z6umfaa20BSC8=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=g1bS48nqamSHEMhhmPjmMPXrLBgLKduzEFltqXoRwCc9rQyiOPUzydi4DFiMx7QV0Ojj+UDFiwo4+HYZ+ye2+fmmey0pWbi9AkzqbbPV7K+0HKG8XmI5iIq1+mxoLp7TCoZTlisojko3o9m7zetr8sEmfK9aUbSEYdKnReLeErA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AXjUEl4U; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3da6f787fc9so2433975ab.0
        for <io-uring@vger.kernel.org>; Tue, 06 May 2025 06:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746539313; x=1747144113; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RwC4YZ71rA9MLO2oFfeduePCyTEcsoamYvXCqtnpzlI=;
        b=AXjUEl4UJ9VR867K25DHXf8XMZ8bVW7/CFWwwZqn2MO1GQdVQ3DjTbIVmvPDhgtXv6
         fAsaQQJSoQEauiZYSXNCStuuwSrixBo16ioKq0/B4n58CKF9cjh2xtS6XuW1ZqCK+vem
         gazJptoedMcwJZ+mfEoVI7Ls18I8lj4D9TiU4NINlotWdh5YNpXDczr5SEQJqAGmF0i3
         VMY5BJJkYAUvIVTFYX0tnV1IanJKFPfpmS1e+JQEK2ESi90tW5rWs0Us81fo1+hs/R1W
         1p17Q63uw0VW41cq+wPnW8cJ+emYHoZeMBZCgXpvbRQcvTOV09HbYsCcZ2gNYPcYJBoE
         WTfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746539313; x=1747144113;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RwC4YZ71rA9MLO2oFfeduePCyTEcsoamYvXCqtnpzlI=;
        b=afsLPgKDUXkWidDYMftAXN4no6AEBsTM/gILsZxWbwd3K+Wpj1KHNaCRvmhh53Qi48
         xPEI0JomBIXnITa6O4U+lCo4UzuLKYQgjcWdMI/A+h1dEfgKfELjkZLPrHbnc37bpuhD
         2gLQ2ToL0Mm+Oe3SVjiDSur4fX+yPZ82nqPGcXYKRCoIIzhd5tZeGSuO04UHzqjUsE/J
         RuPXQS76H0WR4RoQ+RgMQLldR01jQQHSd6GZ8p8VZLp+IE+6F69LHKHlC+8Drpw8iUp7
         i14Dk585wmdvoTwzlEGZYTgQdmdAN6SgmIB6K8J3eY7mUw5wn3m+4Xc5MTA8rSbc0EEW
         /WNQ==
X-Gm-Message-State: AOJu0YyuaIIvwY/CWlRzAK3gxzoRE4WbQGfWg9BDRtAQiP9GypJr4Hia
	hfdokZw0Yjy7VD2+IjFN1G+/W/e9cWVyn0TxXaa7WjqWvlZZzYEXuZiP2Md5SKxrgLW3+PHEU2t
	B
X-Gm-Gg: ASbGncudjXFSW4eOIdlwxG/jau8l2+LqQO3y9LQgzVVqR8kJerK3RoO7ywAimPBK6J8
	eeut2GEqZwk4IklxJvFCADlDy7nHfAcfL+bXQZ4Gb5uiMO6+1G+rNwfzo1l05xfYI+MwhX8n178
	A8ns4hu65jwUUoUnoClu2zHk73HovoOd9x+8G9Ip/BzMbQMBvyKvmJ2LxnszTGcf8/XQHfvyUoC
	D7C1/vCS5OA+Zr+JspTIDfPcLFoDcjdrXRTQ2SnOr2C+5YJwvip2u7F/ijVbDJyKEn9SpxQTrHD
	P5+EyOUOq3DbewzqIyMnsqMYHjI0DUM=
X-Google-Smtp-Source: AGHT+IEurGIM6atNS2e54dYc3/7h8Bp1rXIIH6nPXpPlFdjGjLLMs15nMPNuh7KAPduYLkF2HOYoBA==
X-Received: by 2002:a05:6e02:1fcb:b0:3d4:70ab:f96f with SMTP id e9e14a558f8ab-3d97c199938mr196585325ab.8.1746539312836;
        Tue, 06 May 2025 06:48:32 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d975f58be3sm25930915ab.58.2025.05.06.06.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 06:48:31 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1eb200911255e643bf252a8e65fb2c787340cf18.1746533800.git.asml.silence@gmail.com>
References: <1eb200911255e643bf252a8e65fb2c787340cf18.1746533800.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/timeout: don't export link t-out disarm
 helper
Message-Id: <174653931171.1466231.14715072378498550545.b4-ty@kernel.dk>
Date: Tue, 06 May 2025 07:48:31 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Tue, 06 May 2025 13:30:47 +0100, Pavel Begunkov wrote:
> [__]io_disarm_linked_timeout() are only used inside timeout.c. so
> confine them inside the file.
> 
> 

Applied, thanks!

[1/1] io_uring/timeout: don't export link t-out disarm helper
      commit: 609f8a2577c11c5dfe7274d11a113c31ad388621

Best regards,
-- 
Jens Axboe




