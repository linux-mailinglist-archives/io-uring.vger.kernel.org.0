Return-Path: <io-uring+bounces-8987-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE68AB29553
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:07:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E6A317BF4D
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:07:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B03D421A437;
	Sun, 17 Aug 2025 22:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LEC7d9VH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076CE41C63
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755468442; cv=none; b=mT2NfsRcj3oPIdz73GvI5NhO24E6PgsbpPCV/m9Wmwl8zvLYJtwrUj2+qDiXIjSuw72AUBcUEaM/08BZw3o2i+D40A2wk6MLlfXZah57/q82d5UExu97Uww/dLyqsyCkCD3dwu2k4BlDN+PrU6KjXN8HmyCunY19nKMRqP4o0Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755468442; c=relaxed/simple;
	bh=OZFpk1sAprio5MD5YibK4LuxYV4cuBbHgxDa9Gldct8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cYVLOHSxEeL/78UHE6O5H0C1Hegcv6YH3rL3IIQtWslt2io7F93t5dlPVPgH7juh7Fpt1XXsYVvEG1EZqH1P4ft9e4fY9gbSoiNBh5/rz+fV/jPw26CpcGODKYeSliN23xGFBxi37MDN6q5bzRaGsluY1dY/rSDpcC17/yoyBYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LEC7d9VH; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45a25ce7978so5601155e9.3
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755468439; x=1756073239; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+4TW3KyyMehJGEqo7XJGATzLA+dXwwdrg+uaHD6xWZo=;
        b=LEC7d9VHuMSLZ85qUDuCUgNnGaH7cFpEF3Stv1KI+FPYLjrIUtRfSd+bYXsHvLBYq9
         03ArDpTWQyOrBouxb02viXYbVG0xwOtC1HNlXvUskDU3qAZy/RoUgH+cLZOmCQ/QTwuH
         HsY2+2YpDurxxE34r6A0d2cBUZ2qhGxVbsoHswQ5XwLxiRZrcLZfpRsF1kW+8P5YEJuO
         iRo54K0TC1ljCzZpU6KdmWrqfzsN8T5UZP3k1oRrVgDqVH1OIY1DZPeHaigK8m1JE/jH
         tNjJK/DQdx37vzrIB38IU636BCq8H9YBWI044h7JBJeho/Dan3mXhufKtrpu1H0pzLoC
         mvCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755468439; x=1756073239;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+4TW3KyyMehJGEqo7XJGATzLA+dXwwdrg+uaHD6xWZo=;
        b=cilf3K05hNCy8tT8wHL2133OiI5YeTbtZq8UVGf+gwTX3qXIJryXTFIBWEdXqpgPPe
         VnKfw+MObUHLT2cRT/lLhLd3o3f3/eYw5aiB0IQHu0LZ5wIx+/5h5yCrHxP39SIMYsZm
         lVGjcbntKy0fN70QiWlFCx0x92gpIl3CoamAmvgumYkergOcUZmzcUfBodNRZTuJpKkU
         Ryb/YPjZ7pFKzy3//xcjhylO1bsdU799sp1lKfTT0Qpos0xB7xf0mu6V4D4zSm4ox6O8
         3vMs3ObeGGnu9vKuT6zWjI7W4wTOR1xSwe62lq5156cpiOc2gcskIy30WHZWXLc8/aU8
         r7Ww==
X-Forwarded-Encrypted: i=1; AJvYcCX9k9ddwIcyOF3IAB3HeIZ9XHvYvlqIrFvhOovDNnLGvS5lOfIaHcIzTJ0vQ/ydUjXT423rd7cd+Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3oK+endPvRS/A6b5wK1xbvB1leFGtUfUvz39KQT0VSXuUa9Qm
	tXk/1P2cfC179Hcs6N/Q5oGoOVu6ICZFqK0R0FkVViwMgS+sJiAqL2LUuMHCSw==
X-Gm-Gg: ASbGnctFhT4kH+JweZcX7k1vIIYVnBqVJrqtTAmFDhK7PmA5mtyZ0cfokRYZjOMO86c
	rWkZgOoGA7xpM/1eXfyZXFYeH/btS9tDlqOzolDfeNKuMj4EGkRyVAIdDNPK+M/U2331eam0hkB
	+Jp0JGGe/CqwXyJxnFCuAnUXOJbhaXDMHYUrr+rPNIKWC7OBHfVfLz+6TGEbuyH51Xtn0XFOoVk
	o8Q9z5oeCWfJ3oJ3B/nSE1Acc56ib5xTrKyNwR2fjbSg38Ghr4CNS6V3/Bkfa18YdLAOHzMe8GG
	LDfZYombrDPpnbh2Q+ftu9LsuSniyrjXtRTf6q7to99tff+wQ/LewtWqb73gpiIRDUABIc0oAlx
	z6h94d4x0Pvnpu5RLuv+nN5HPhpgkN0H43hfHdSfz
X-Google-Smtp-Source: AGHT+IEWNfmhEOrUkMkj8FGnjLO4mUdcinlE7BpsjISMw+YOANRnlZOQHiSFZ3raxtH54WrLxcuVNw==
X-Received: by 2002:a05:6000:2c04:b0:3b8:d0bb:7554 with SMTP id ffacd0b85a97d-3bb6617ea0amr6420068f8f.7.1755468439097;
        Sun, 17 Aug 2025 15:07:19 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b26a3dcsm80185505e9.2.2025.08.17.15.07.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Aug 2025 15:07:18 -0700 (PDT)
Message-ID: <873ab36d-65aa-481a-b056-8f475a56b5e7@gmail.com>
Date: Sun, 17 Aug 2025 23:08:30 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: io_uring: add request poisoning
To: syzbot ci <syzbot+ci13e386d4235544e2@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <68a03392.050a0220.e29e5.0041.GAE@google.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <68a03392.050a0220.e29e5.0041.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/16/25 08:30, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v1] io_uring: add request poisoning
> https://lore.kernel.org/all/b98edbb8ec4495b053dfb11cb3588f17f5253b6e.1755182071.git.asml.silence@gmail.com
> * [PATCH 1/1] io_uring: add request poisoning
> 
> and found the following issue:
> general protection fault in __io_queue_proc

It dug up a hack poll_add does to initialise ->async_data. Not a
pre-existent bug, but definitely one of the things the patch is
supposed to uncover. I'll update it.

-- 
Pavel Begunkov


