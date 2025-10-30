Return-Path: <io-uring+bounces-10293-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E7A3C1E062
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 02:31:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E138D349D1B
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 01:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDF1319539F;
	Thu, 30 Oct 2025 01:30:55 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from bolinlang.com (unknown [155.138.147.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F45737A3D8
	for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 01:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=155.138.147.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761787855; cv=none; b=KIEQO1lMeTSpsnG4/4aTcaKMdrYc9rMP/jvaWic5ymOvtcDU94kFY3a+HHBOdlnNR6QD8y9t5Zd7m8Z4PfgsQwfsauYD/abRGu2gumTSjsE7BZBCCwxkPkVoydf64QIGztWNGOP2YzVyePF/zLcEflNqvMM4mbUDMFNjBeA2vF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761787855; c=relaxed/simple;
	bh=5IKE55apCQeqaD3saLQnKBiYJI0W+9Vp+8n9KhNYe28=;
	h=From:To:Subject:Date:Message-Id; b=O2RSY+ISMN1H6o36viG3HSkjcyExMwynThY3YiefIyGoL3lZeG2s4ZTFDBev8AKpMpv+fK6U1Fvkyq4er5iN8mKukdC9ewYT6WVe4ZUyjLWVyHnkrEgaw2rARrl8tTAgQefzE+DzbcugC/n7K8HMGkkzd9LQzvJdNMCpAoOK5vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bolinlang.com; spf=pass smtp.mailfrom=bolinlang.com; arc=none smtp.client-ip=155.138.147.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bolinlang.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bolinlang.com
Received: by bolinlang.com (Postfix, from userid 1001)
	id 3BF0517C155; Thu, 30 Oct 2025 01:30:53 +0000 (UTC)
From: Levo D <levoplusplusio@bolinlang.com>
To: <io-uring@vger.kernel.org>
Subject: Does io_uring_enter have anti-deadlock magic?
User-Agent: mail (GNU Mailutils 3.19)
Date: Thu, 30 Oct 2025 01:30:53 +0000
Message-Id: <20251030013053.3BF0517C155@bolinlang.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

Sorry, Ignore my previous message. My original problem was I didn't check if I added something to the queue and my second problem was forgetting to change IORING_ENTER_SQ_WAIT back to IORING_ENTER_GETEVENTS. I guess this is what I get for debugging/emailing right before the world series

