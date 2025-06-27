Return-Path: <io-uring+bounces-8514-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF12BAEBE8E
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 19:46:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F00A04A7CDC
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 17:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BADC41B6D06;
	Fri, 27 Jun 2025 17:45:57 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from bolin (vbox.bolinlang.com [155.138.147.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2AF38DF9
	for <io-uring@vger.kernel.org>; Fri, 27 Jun 2025 17:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=155.138.147.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751046357; cv=none; b=Wi59P7K47LPqAv9WeZE5LdHGfoUo7C4NIRumyB4cgjJ393vZKiy1lM9y64/dFbN7e5XbBHYiA7Q6ar/a9hRm6T10nyW7mjzsJXFbLJPKLEEIgXWkFhw5wercptamBjn4bYAMLO8FFWImSa3QicxPRoSg3m7oRmq6lgkpP2IJpc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751046357; c=relaxed/simple;
	bh=W0zB6a4CvgrwvH8KDHYrYFbIk5to+3qYkJEjVUvgeGU=;
	h=From:To:Subject:Date:Message-Id; b=kYh8x6qxmZ/q39wYWU19fPYJOqddQdh6BzTmoV0Zg00cXk/1gn50sN1QtA0jZFx0m5SktaWsqX6x5wDhAd8zN8aKNOJjacFVdSgaLCuytnK8e7Ry63auLhGqgWSpaPfvmmfVFZeTapEBHiqHYs1zwVYRHwiic/WHqWSp4MjHNFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=mail9fcb1a.bolinlang.com; spf=none smtp.mailfrom=mail9fcb1a.bolinlang.com; arc=none smtp.client-ip=155.138.147.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=mail9fcb1a.bolinlang.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mail9fcb1a.bolinlang.com
Received: by bolin (Postfix, from userid 1000)
	id 6C2B2FA82E; Fri, 27 Jun 2025 17:45:48 +0000 (UTC)
From: Levo D <l-asm@mail9fcb1a.bolinlang.com>
To: <io-uring@vger.kernel.org>
Subject: Place to read io_uring design?
User-Agent: mail (GNU Mailutils 3.15)
Date: Fri, 27 Jun 2025 17:45:48 +0000
Message-Id: <20250627174548.6C2B2FA82E@bolin>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

I didn't see any pages about io uring design, could I ask questions about it here? I can start with simple. In the submission and completion offset struct, the mask (and flags) holds a 32bit index for us to get a 32bit value. Why not have it hold the value instead and remove offsets from the struct name? It makes me suspecious that the mask can change?

Another one is why have an offset table at all? Wouldn't it make everything more simple if there were a set of entry values we can pick from with a decaded struct for it? Wouldn't that make both user and kernel space more simple? I have no idea what value is most optimal for my usecase and picking one from a known list of values would have been nice. I see the man pages have been updated since I last read them so I'll be rereading them

