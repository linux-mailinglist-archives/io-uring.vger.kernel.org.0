Return-Path: <io-uring+bounces-5880-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB98CA127E6
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 16:54:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5B5416089E
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 15:54:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B68E146D40;
	Wed, 15 Jan 2025 15:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="14IHtEjt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC61620326
	for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 15:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736956457; cv=none; b=D+/T6Aw1rpQqE7C332nGYiQEECq5V28MKLddUsRohBsHBm4zE7hFkmf2z8OwCOWimedc1x4YyK1DKC1rK4hxFITZ9XYh4LcZuT6RAGOEGkuy8wkSbVURkpV1JHkhJW1N7QYTVdxpanJdseWjXrVDOM85dqgbD5/vYK8shgEk358=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736956457; c=relaxed/simple;
	bh=xzcZYYEuyIgk4NxbKptmyGFPh/tMUcgSvP8kNDPWRqE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=n7JAGbC8qy8BLB/nlzV00mLgKE4R09pMICnA1KGkXVEytbOvrOJjqLaRakQTpdLMPZAxR1PRhcGxdw2lcNxRk3CJ5wSGUC6R6vGY047/jJ1Wg/ApA6Q5SuNygJ6s3TOxLbDGK3oo9lF45u4EKZOviSeJNKRptOVs6azFtpvA8lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=14IHtEjt; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3ce8c069840so3078465ab.3
        for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 07:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736956454; x=1737561254; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6jK3YYBza9vIfeWnYbhhFRcvJeAVzi+RxxtLKtWp2I0=;
        b=14IHtEjt+hvaqG0m4ne6rhfzwqpKP4UD0g/z0KJW+J+pb4lDFwHfFhQB0pmefKkODs
         Bh2FhuUg4K7dqfy7bzjHZw0jB76oNH3+OxAptgmU5g1kpn3L33C1EOrKV2OstnvnVb0g
         AX1F9LoLOOc75RexKmWrw/1cOvlPQuhnHI+sBc1HYdRl+LsS++bcuIUkOJFVPgt+zz5T
         R0GlxlQfybNRmPnw9wLIpNxcKk5N5jQ3WHrdeI3K9SIRPx3vxFhfk4ozLaSIzPajmHm+
         Zs4ex39sMp5vdL8OVDVNdQ3MPS+3W8fPRnIP+E3MdySZqjiqfSp8y+2l9gQzg0GPFirM
         S8Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736956454; x=1737561254;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6jK3YYBza9vIfeWnYbhhFRcvJeAVzi+RxxtLKtWp2I0=;
        b=L2+CKgHT4HzC/cvb+AamngELwNsL6ygn5nVa9fU1ik798cUJpBuEnWKTRM/r5RFHat
         Ffq7Sc3V9tE3fn3LvRPtAZaWzEpO8pV7C91fRb3fb8bI4Ee1CD/HNyflmsH95p+w0QDK
         yoRrq1pbSbRsirBILk7a9ALa4mycLYgwJGHCK+1LaaWQw0wN8sdQ1AkWFQZWkU93XbVo
         6XLyNBeQW7zob7RXqSJyUsccTpN6Db2CfhmMUVlyemsD8hEMiCK1+nOZ9KzY6cusnpMp
         fa7yo2sXuRt1co32nmZYF10bq/0tjUttehZ1oR/tI8l38ty2gXUXY7S24sOlt4H404oT
         mgBA==
X-Gm-Message-State: AOJu0YzXJu7coh9gDIlw1bUMQAkrneL02TqfYYzuM5Ml9cz11qfNtFR7
	dw6LXTq94vTwttG0UKV9wbdFmy4oibR0Wh4eXM4aQnr/yW4m5u9X8KVz40TGxa/w8B963mEuaug
	a
X-Gm-Gg: ASbGnctemLONTT+TqnNFEGjrGC6d+xvnU5Klx6DXHKYFfV6yM8y4oCWcwrNMltOvCNW
	ghrPGut9GPAAHWOj0BnSR2jaB9VaNkOQgfRrktVFcnA1RIFp4+yI8CGliQyC4m7F6ALlVugmZkm
	DlFSjI075aXN7q8B8Rb9DFCspLLDKLS1g+qFZGzoriVCnAhuLkyLLbc5ct3fY96VNGUn5oVNDS2
	hdix8HdaSdBGIyXeatt/c0N3wQpkHCridrBILo5S9hFzzk=
X-Google-Smtp-Source: AGHT+IEOwSiNPl2l5Jrb54vp4Lofy/jtsqOKrlV2IFRu+UKFWETEpJYadB2Qj2vBScq934zKxiWpvw==
X-Received: by 2002:a05:6e02:1f02:b0:3a7:c5b1:a55e with SMTP id e9e14a558f8ab-3ce3a7a8aa1mr243206535ab.0.1736956454513;
        Wed, 15 Jan 2025 07:54:14 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b61322csm4158781173.57.2025.01.15.07.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 07:54:13 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Josh Triplett <josh@joshtriplett.org>
Cc: io-uring@vger.kernel.org
In-Reply-To: <9bac2b4d1b9b9ab41c55ea3816021be847f354df.1736932318.git.josh@joshtriplett.org>
References: <9bac2b4d1b9b9ab41c55ea3816021be847f354df.1736932318.git.josh@joshtriplett.org>
Subject: Re: [PATCH] io_uring: Factor out a function to parse restrictions
Message-Id: <173695645373.21323.12087670594975226895.b4-ty@kernel.dk>
Date: Wed, 15 Jan 2025 08:54:13 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Wed, 15 Jan 2025 11:14:33 +0200, Josh Triplett wrote:
> Preparation for subsequent work on inherited restrictions.
> 
> 

Applied, thanks!

[1/1] io_uring: Factor out a function to parse restrictions
      (no commit info)

Best regards,
-- 
Jens Axboe




