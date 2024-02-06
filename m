Return-Path: <io-uring+bounces-540-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4224484BAD5
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:24:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC26E28578D
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:24:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F3B134CF4;
	Tue,  6 Feb 2024 16:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="oZzE5/0n"
X-Original-To: io-uring+bounces-533-xuanzhuo=linux.alibaba.com@vger.kernel.org
Received: from out0-178.static.mail.aliyun.com (out0-178.static.mail.aliyun.com [59.82.0.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78813134CF1
	for <io-uring+bounces-533-xuanzhuo=linux.alibaba.com@vger.kernel.org>; Tue,  6 Feb 2024 16:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=59.82.0.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707236667; cv=none; b=TI0Rc/uRzkyEUNgnX9+uzJk2ZLKNtu0oIfVP7HvpEJ4Itiq5JPuGCVUSqw4BZ1I5bML0EIOztbYudsYdAqx47kRLM/qoOy5H7IgAhcmmkNWIyKOSN5rQq+P9joYVnm4/wINUjCJevarxiB8Ixv+z49uh0SWT1U3yKviZBAPWOTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707236667; c=relaxed/simple;
	bh=a+BuHGTS9P2uQPIBTFfFeLBBud0i07Omu7OakIuFqGU=;
	h=date:from:subject:to:message-id:MIME-Version:Content-Type; b=NQ6/roIVAwuDV644FO36X6mRT+F5tF2mC3m87lCX7KsfR27q73ZfSZlxudQmCSx/GPCQn6EP3iRHrV2ewXFu0BYTSajm8XPrwgpPamNJP12bq6hEAuQ1TyKbgHK3sXW9eI4dkjlFV40RFDW1vttfpx2hs9n3xmFywoQphFsm3L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=oZzE5/0n; arc=none smtp.client-ip=59.82.0.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1707236661; h=date:from:subject:to:message-id:MIME-Version:Content-Type;
	bh=a+BuHGTS9P2uQPIBTFfFeLBBud0i07Omu7OakIuFqGU=;
	b=oZzE5/0nKAxt7iXQQ2795bHVDyWv6mbxru6lUy18yC+v+CSNNvLUB1IaEs/kRa1LeEpXVfn7bYpdg/GNKVm7ZjGqZqvUq4C4gqZUSS5Zifvw3nitoDp2+sTrGLJSY6V36rwscYr4ViycYvk6rR5GY+WA05HlqMnW9tSt1+eDiaY=
auto-submitted:auto-replied
date:Wed, 07 Feb 2024 00:24:21 +0800
from: <xuanzhuo@linux.alibaba.com>
subject:=?UTF-8?B?UmU6W1BBVENIU0VUIG5leHQgMC82XSBNaXNjIGNsZWFudXBzIC8gb3B0aW1pemF0aW9ucw==?=
to:io-uring@vger.kernel.org
message-id: 1997aee3-fcf7-4337-b57c-7207ff319ccd
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

