Return-Path: <io-uring+bounces-585-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E20C184E7BF
	for <lists+io-uring@lfdr.de>; Thu,  8 Feb 2024 19:34:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A68CE28EDEB
	for <lists+io-uring@lfdr.de>; Thu,  8 Feb 2024 18:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58237DF57;
	Thu,  8 Feb 2024 18:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="HOPBpnk3"
X-Original-To: io-uring+bounces-584-xuanzhuo=linux.alibaba.com@vger.kernel.org
Received: from out199-22.us.a.mail.aliyun.com (out199-22.us.a.mail.aliyun.com [47.90.199.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159644C7C
	for <io-uring+bounces-584-xuanzhuo=linux.alibaba.com@vger.kernel.org>; Thu,  8 Feb 2024 18:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.199.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707417256; cv=none; b=PwBLir0f3sS8wtDuFPiPGJ1JMFPkFb0xvFgsftoIra6pLBCSC8TzPu3vXa3OvCTnCjYRQJGaiQBmh+J8EuIbEMRA5Ubn9NHPrdszYx2lFKHtfbv2nCFCxYEcy4uNfUxYmloiNOdAWpqFZtZXWe5KdS0nFrNtErFsEHwPjgqWJoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707417256; c=relaxed/simple;
	bh=a+BuHGTS9P2uQPIBTFfFeLBBud0i07Omu7OakIuFqGU=;
	h=date:from:subject:to:message-id:MIME-Version:Content-Type; b=l9OdFVJhULsgSaxU0R9QFCePq17Zzai5ILbTmNkWeCudaER4vwSJFDUM452Wno/U1Kh8PaOOmoTkSDCR0BE79VHNbr3VjZuDd996bdg2L4UQwCGq9lPMIQ3UuTzbGOVa4FMSjnNOG9jRXchxzyZ9AzJHdOPhiiHj9vDh61yFmq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=HOPBpnk3; arc=none smtp.client-ip=47.90.199.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1707417235; h=date:from:subject:to:message-id:MIME-Version:Content-Type;
	bh=a+BuHGTS9P2uQPIBTFfFeLBBud0i07Omu7OakIuFqGU=;
	b=HOPBpnk30qTd2bxndy2K/cnne0DXjvWZk4AQRYFHFWJWmt8E7t11If+RY07G5xAOeKE49+f2T9qnkIMwJxQKodYXuLZohPumdy2JaeLnPIjKoIEZqkxbZaUzZSawYjwhcmJfAn5fuUYUFHlvepPaUBvb4qptUuzcuxaN7Mi2Qx4=
auto-submitted:auto-replied
date:Fri, 09 Feb 2024 02:33:55 +0800
from: <xuanzhuo@linux.alibaba.com>
subject:=?UTF-8?B?UmU6UmU6IFtQQVRDSF0gaW9fdXJpbmc6IFNpbXBsaWZ5IHRoZSBhbGxvY2F0aW9uIG9mIHNsYWIgY2FjaGVz?=
to:io-uring@vger.kernel.org
message-id: 9e5faea7-dd5b-4407-bd0a-97aa16cd7c51
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version:1.0
Content-Type:text/plain;
	charset="utf-8"

Hi, I'm on vacation. I'll get back to you when I'm done with this vacation.
I'll be back on 2.18.

Thanks.

