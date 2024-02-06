Return-Path: <io-uring+bounces-531-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9641C84AF2A
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 08:45:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B91091C2215B
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 07:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 278EE7319C;
	Tue,  6 Feb 2024 07:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="TbQbTPWq"
X-Original-To: io-uring+bounces-529-xuanzhuo=linux.alibaba.com@vger.kernel.org
Received: from out0-177.static.mail.aliyun.com (out0-177.static.mail.aliyun.com [59.82.0.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A00339AD5
	for <io-uring+bounces-529-xuanzhuo=linux.alibaba.com@vger.kernel.org>; Tue,  6 Feb 2024 07:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=59.82.0.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707205524; cv=none; b=vEO2qjkXPDqQE8ebpS7d3oSabQb4o+5pQxtva4CrwqzL59XqizeMwXqtYc5IatDa98G4vSmQ8Ypt1jAXpShtL+DAFo7iXM8ggkBL9lJrE9WkgYSZbzPThSSWYue850Pg7yKHA4nHDztje2oRk+azRDp4zYEDOo42xitlkPUMDKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707205524; c=relaxed/simple;
	bh=a+BuHGTS9P2uQPIBTFfFeLBBud0i07Omu7OakIuFqGU=;
	h=date:from:subject:to:message-id:MIME-Version:Content-Type; b=iaQzAyuGXp1FX2eyUKVJ/DXX7LAozz8btKwJ0b0pOABeF/NjtYiOAY9Yi33f8em1u6Fxv6lALY3gnWu4QVuyA5+0ljA4KugmPJSAEy4nCn9XJjAtLyzCWAf/spYAqRAkBlQf3LIl1hDMFj+DxvfBMfyiQpo8aOcVJ8pgDuL1vQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=TbQbTPWq; arc=none smtp.client-ip=59.82.0.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1707205512; h=date:from:subject:to:message-id:MIME-Version:Content-Type;
	bh=a+BuHGTS9P2uQPIBTFfFeLBBud0i07Omu7OakIuFqGU=;
	b=TbQbTPWq63OYmQ3ZB6D+NqaztdchNbeJWbGaF8GhqPq21cSpdit1GOX5epl3tW+B/+2pY9Nu7dH18cvl6w9dvBuEM/fmGvYhYeF3te7yP6yAhU68m/tNeA1U07cUXxd28zjvHP9hvECTQLnL5AedODB76nvZS0f3Ig80wQ5VrD4=
auto-submitted:auto-replied
date:Tue, 06 Feb 2024 15:45:12 +0800
from: <xuanzhuo@linux.alibaba.com>
subject:=?UTF-8?B?UmU6W1BBVENIIHY4XSBpb191cmluZzogU3RhdGlzdGljcyBvZiB0aGUgdHJ1ZSB1dGlsaXphdGlvbiBvZiBzcSB0aHJlYWRzLg==?=
to:io-uring@vger.kernel.org
message-id: 25fdb2e4-e6d3-4d1c-b65a-9065c8d63d3c
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

