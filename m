Return-Path: <io-uring+bounces-6319-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 371D6A2D3DE
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 05:49:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42C393AC20A
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 04:49:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A08414B5AE;
	Sat,  8 Feb 2025 04:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=truemaisha.co.tz header.i=@truemaisha.co.tz header.b="dDo/t42z"
X-Original-To: io-uring@vger.kernel.org
Received: from server-598995.kolorio.com (server-598995.kolorio.com [162.241.152.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47806137E
	for <io-uring@vger.kernel.org>; Sat,  8 Feb 2025 04:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.241.152.247
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738990152; cv=none; b=d1sbEkga7D3vVhxe8UukQ0NmcxqgWWNCAAlbLTkRwijPzi84KgwxUGbfLcXKu0rCrKB6mT6knEyaWpiitPM9ASyTrnVLQDFI9zVNNeEbJS0ssMCJ7DluCvKPvflHFjYFi5Kl/ZjlVQSk2/LmAIk5YWzuDzNL5FZfBwvW6in1Dm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738990152; c=relaxed/simple;
	bh=gl4+7vNxgV9+JzZtw7EthQ6aGDgi0WVn3wQV/lnKiyo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YmPSptog7dugglQNgsiM0ErvpWr3TFnXTeRYVTa0CPKlvIVdID9VdvcDTfR+ihfJtR5SEVcUaKH3dPbdJsxWw349RGhSFpiCeVUosUYmEGKQp+XH3l4hk14aUIfJBKBBhbfp9pA2hLCdED3bYeuJK7TxorpKKtFWV7rpF1K2jn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=truemaisha.co.tz; spf=pass smtp.mailfrom=truemaisha.co.tz; dkim=pass (2048-bit key) header.d=truemaisha.co.tz header.i=@truemaisha.co.tz header.b=dDo/t42z; arc=none smtp.client-ip=162.241.152.247
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=truemaisha.co.tz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=truemaisha.co.tz
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=truemaisha.co.tz; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:To:From:Reply-To:Sender:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gl4+7vNxgV9+JzZtw7EthQ6aGDgi0WVn3wQV/lnKiyo=; b=dDo/t42z9kf2x3W/weePiFQy7W
	4H/n4J6HTrsJKoboodj6UmREST9pTIqTI6BrWoK2fPK9JMcC/AfQiuuSSKg8lh8lLJxMFp7PNhZjr
	ZQGCjpPzX5VtEBIbcTVdWVwc7/2vS8m4mWawjf+9ARkDd5ca5W06X78wQy8YdWdI1l10HALJ9WOK/
	ZeEf7tYOq6NXU0yEwWu6pDJpD2Im/iyA1Wxlbi41GrDggM5Q1YLghbB0MN3AR1JysuMXqbU2VeEX7
	PWFddgxm0wI0/rg9WkZTfsDle5rsWzfJ43nBiPN4gpfRIdWtzF4RCVfoysQrjUOYxEDW4f6VkTAzf
	+RfZ7Kyg==;
Received: from [74.208.124.33] (port=51473 helo=truemaisha.co.tz)
	by server-598995.kolorio.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <chrispinerick@truemaisha.co.tz>)
	id 1tgcmA-0008Hh-1f
	for io-uring@vger.kernel.org;
	Fri, 07 Feb 2025 22:49:07 -0600
Reply-To: dsong@aa4financialservice.com
From: David Song <chrispinerick@truemaisha.co.tz>
To: io-uring@vger.kernel.org
Subject: Re: The business loan- 
Date: 08 Feb 2025 04:49:08 +0000
Message-ID: <20250208015433.5694E089A060B8DE@truemaisha.co.tz>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server-598995.kolorio.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - truemaisha.co.tz
X-Get-Message-Sender-Via: server-598995.kolorio.com: authenticated_id: chrispinerick@truemaisha.co.tz
X-Authenticated-Sender: server-598995.kolorio.com: chrispinerick@truemaisha.co.tz
X-Source: 
X-Source-Args: 
X-Source-Dir: 

Hello,

My name is David Song, at AA4 FS, we are a consultancy and
brokerage Firm specializing in Growth Financial Loan and joint
partnership venture. We specialize in investments in all Private
and public sectors in a broad range of areas within our Financial
Investment Services.

 We are experts in financial and operational management, due
diligence and capital planning in all markets and industries. Our
Investors wish to invest in any viable Project presented by your
Management after reviews on your Business Project Presentation
Plan.

 We look forward to your Swift response. We also offer commission
to consultants and brokers for any partnership referrals.

 Regards,
David Song
Senior Broker

AA4 Financial Services
13 Wonersh Way, Cheam,
Sutton, Surrey, SM2 7LX
Email: dsong@aa4financialservice.com


