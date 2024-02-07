Return-Path: <io-uring+bounces-572-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4791D84CF09
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 17:38:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A84C1C21F7C
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 16:38:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A6182889;
	Wed,  7 Feb 2024 16:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="vLIzpBZ6"
X-Original-To: io-uring+bounces-571-xuanzhuo=linux.alibaba.com@vger.kernel.org
Received: from out0-239.static.mail.aliyun.com (out0-239.static.mail.aliyun.com [59.82.0.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5918654649
	for <io-uring+bounces-571-xuanzhuo=linux.alibaba.com@vger.kernel.org>; Wed,  7 Feb 2024 16:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=59.82.0.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707323862; cv=none; b=U2hME0IqSS1zr1aDgsUa65Tz0n1UR+4EzfEQmlqTfec5YP4hS9kjhoHrKkEMKa7L26KBCbf250P5d+px4xyD+0uz78OWoTFn2nKQnhUZ/YwXPDghJ3f0Ug4ZrRzCZwzlaTBILNOxSLv8pVYsAqYdMa+/gFyGVnQDlvD1CYLqiUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707323862; c=relaxed/simple;
	bh=a+BuHGTS9P2uQPIBTFfFeLBBud0i07Omu7OakIuFqGU=;
	h=date:from:subject:to:message-id:MIME-Version:Content-Type; b=koW0J3CjRZqg8WfBi9IXQksOogwOtGt7FogO/7ul3rdNjf3KoZy7MKFkYVJzFb1yxTaHT1wf6wFFvCH8MEUXFoEcYF6KLfsyfIX3+1HcUocXib34xSVMetaEk4oe1A2mYMjm07vUDkh48idEgpUMOiofStSnoUFXa1lWHuRP1W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=vLIzpBZ6; arc=none smtp.client-ip=59.82.0.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1707323851; h=date:from:subject:to:message-id:MIME-Version:Content-Type;
	bh=a+BuHGTS9P2uQPIBTFfFeLBBud0i07Omu7OakIuFqGU=;
	b=vLIzpBZ6o9urGISZ7XDZ5A9N4AsBufFG+DJXWW22ESf6IRmEXJVHwCqMez+5pxG6gQ8mFzJOLZ8LdZtn+LgQDHhcsLp0M/WxyZy/CnOOwClhkDgz68CQky2cbzTIQavrwDhZUZCjBGYG7kJBkcHXZh5BQp3BPpws6E/W+Hq3G6s=
auto-submitted:auto-replied
date:Thu, 08 Feb 2024 00:37:30 +0800
from: <xuanzhuo@linux.alibaba.com>
subject:=?UTF-8?B?UmU6UmU6IFtidWcgcmVwb3J0XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUgcGFnZSBmYXVsdCBmb3IgYWRkcmVzczogMDAwMDAwMDJkZTNhYzg0MQ==?=
to:io-uring@vger.kernel.org
message-id: d0c5d9ed-9a2a-4164-9bd1-1f5906a4bb40
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

