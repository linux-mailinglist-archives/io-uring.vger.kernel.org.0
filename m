Return-Path: <io-uring+bounces-10384-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E68DDC375E4
	for <lists+io-uring@lfdr.de>; Wed, 05 Nov 2025 19:45:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AB3D34E16B0
	for <lists+io-uring@lfdr.de>; Wed,  5 Nov 2025 18:45:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D11BA263F30;
	Wed,  5 Nov 2025 18:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0B4VWwRw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D962263899
	for <io-uring@vger.kernel.org>; Wed,  5 Nov 2025 18:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762368345; cv=none; b=UHtV6eXaswnTfodfxRT05++8Zw3o48XXirPFglVqw2nbBiIDJhs/Ry6vBrUPdmf4cG9uiSUqrMH8CAZLP1I0xkwaLiEW9ilmBStcPYvebzNCoDMdVZtV1B5NOxmn9I9xbZUwN8s6wH6tfcBJbqKu03LCvS1udKCAM6gKE+RS6PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762368345; c=relaxed/simple;
	bh=qORwXP6mu8Pk8CRemLABHxDGxEFBaRhfIL+CNa/mrgA=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=LSeAVdwcAQIQIsv8hIIA80BGYYTNWNuMqQKDnQ1FM/5VdBfo3HA9HqbFFAPbEZVNZRz/+5bhldszs08Oo54Nj6bAWtrS43VnpvWDwkQnSm2BveWybr0CWbWMTdaDbEAM8t7G0WM8eQvh9bx5+ZV6vNCryFbmQ7q5w5OXBA0muyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0B4VWwRw; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-4330e3080bfso377855ab.2
        for <io-uring@vger.kernel.org>; Wed, 05 Nov 2025 10:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762368342; x=1762973142; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7CqSjmIb2ZR2iYx3WnIvfi3D0Xe3LGSbKBATN0mPE2Y=;
        b=0B4VWwRwrNdpUQJM0ph7GJ43EJ93xzq3jA7rJDcUYibl6jqcv2Cwuqr394vNmCXIyf
         mXK8T0pPtSJ3J8DYuGuxshIWOtwHi7CJke79q5p3Hsz2mVQwa2MQxL98Ui5cTDgV2FKb
         UtYel871p7lENi88rs9CjVPd9UXQosz2qmgf1E+ymer1ie4cLiHj3VWZYaU3TcftjHk2
         MP793yKLD0/gkRtQUKSHn9ucUFgSF/Gsce0lrFVBRKUEbCLgahgPvEh2isf37xqTXnkd
         YRZMchAr27mDeHztOVJTimJgywFp54Jfywi0W1YZ3Tf69mSyhiZbHoVtd+UIqOp9Xt7m
         gWtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762368342; x=1762973142;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7CqSjmIb2ZR2iYx3WnIvfi3D0Xe3LGSbKBATN0mPE2Y=;
        b=Mcq1mji0Ukn1aEMWsnhCLQV49Bv4hhj/82KOpLe6apTe+INBKIpbpYWO5m7fSJl2QP
         xmAdBFgBcp+EyBMqo+pEMWm4POXh8LdWuidpETN78eMpw5mthsmPAnc+j+62PWpCsbpw
         5JQjnddzeOLWoAJMA/rY4Cqfi4om6XwTtgHfmzu6Dxcg/JXAVyJXCpD7Thohm4b17x2z
         RqbAWCycInzlzGKcDmQ2FdaNfN1gFQ7WiAUTz5WjYTY6WFIX1v4bksizUoKsNHgmj9rd
         Ie457KBmH1fSKb7UzsoHHh5W547hTeqaTLyp9bvpL7/5HcLMnWJOnt9ZTtmVpwI6gWo4
         +lIw==
X-Gm-Message-State: AOJu0Yx7v9IOOIbo0VN/29zOAeFmV4VnQx/KR1oLmrG/F7WzVIcLnUg/
	vP/nYqxI2jIEutMMDVGVUZ96tYLgmC/y/h1tRdolsye551fgqdxeCcmralMdcdXAXBwk4YoK4pH
	uHXej
X-Gm-Gg: ASbGncsnk6IUwWBYySqroN8vpOzisZ3kOCttkXJnfB6DVbxBS2KnYe0jnb0fuso04f7
	+xoplhOdAiHlpkFq/QB1vxuTW7odjCjYC7TkEgy42saTM6+uIbOTESnWxvC9GS8On4tHj4/87ov
	sm4zDmtGl2VsB6s9Zoa/tGIRNKXTst3dbfMXTAzqBogLXXGxuSvNymtcj4Uv47PWYncuyW7Cw4i
	aPlVILip2GqiOO2Bo4yFHem7zwIew7EzsaWYBx3gi4mRPA3U8Ck5SlShjPBA4N/m+6RXoN8dLDJ
	CkNgZkP9ByTdnj2bn0/55DZSoxJJdXtGHpgHOEETXNBL4HovuA2IhOWa8mHARsO4EmpCM20kigh
	8v/ao1cWALW3XdAzM8MlllXoaaJSGoYfRMklMi3Q=
X-Google-Smtp-Source: AGHT+IGXKL99s8sXwxRrLp3hBwhFsj8E/tGT8AQZBza/2hv81ZWxogsjFRtIGBJ0iQjo89Yr6sRqKw==
X-Received: by 2002:a05:6e02:1608:b0:433:283c:ba5 with SMTP id e9e14a558f8ab-433407d9a9fmr54525965ab.18.1762368342367;
        Wed, 05 Nov 2025 10:45:42 -0800 (PST)
Received: from [127.0.0.1] ([99.196.133.153])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-4334f4e37c2sm386735ab.26.2025.11.05.10.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 10:45:41 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f883c8cca557438e70423b4831d2e8d17a4eeaf4.1762357551.git.asml.silence@gmail.com>
References: <f883c8cca557438e70423b4831d2e8d17a4eeaf4.1762357551.git.asml.silence@gmail.com>
Subject: Re: [PATCH io_uring-6.18 1/1] io_uring: fix types for region size
 calulation
Message-Id: <176236833752.194552.4065753626102400733.b4-ty@kernel.dk>
Date: Wed, 05 Nov 2025 11:45:37 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 05 Nov 2025 15:47:01 +0000, Pavel Begunkov wrote:
> ->nr_pages is int, it needs type extension before calculating the region
> size.
> 
> 

Applied, thanks!

[1/1] io_uring: fix types for region size calulation
      commit: 1fd5367391bf0eeb09e624c4ab45121b54eaab96

Best regards,
-- 
Jens Axboe




