Return-Path: <io-uring+bounces-11128-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CB42ECC510C
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 21:09:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 676B7303894B
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 20:09:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEA6632B9AA;
	Tue, 16 Dec 2025 20:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S89KkUna"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f68.google.com (mail-lf1-f68.google.com [209.85.167.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50D42750E6
	for <io-uring@vger.kernel.org>; Tue, 16 Dec 2025 20:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765915746; cv=none; b=ZSLA22ZWzxuaYA2hnQfgLt48cKBo8p5n5IVIdiZBGljjYg0qwXtjHl7vJMi8wkqCvWgQGvGrA2RSx0qZ5omGAaHiFxG3sbhCbV5IYNYYNdecT59BWAg5/8BIvn6EXseb0GVDL5d8A5Bb84+SxoonE8e+cptA3VcsgDKNQILMFek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765915746; c=relaxed/simple;
	bh=kIhSKDmibiZeir6cA6DLCbZr7ql+u1kAXnIHyYbuQVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SS9C2vd2/9qR/6aIuwfd1t1TsPkmn4XYZWDwdOhoXJwW9yVJSkUufcz2t67O5ZFvnF5jcptKpU1m7ZaLPAO8rz44yu63UBhZLFs6Y+EnScgDDGHJbeV8CSn+FbzV7g6uPr7uE0r2NgEXiplhcwWnNr/jsCIJQFDkBfiDY37RMeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S89KkUna; arc=none smtp.client-ip=209.85.167.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f68.google.com with SMTP id 2adb3069b0e04-596ba05aaecso5676391e87.0
        for <io-uring@vger.kernel.org>; Tue, 16 Dec 2025 12:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765915743; x=1766520543; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i1bbnR9hzdM9Uf+6FrzBwEhl6E+6kDOhpZpgPAvE7Vg=;
        b=S89KkUnaqoFYdw+5He12dGILB4/8WVzBmYaCGuP3wwjIf3verZO3h6yhqkOveTTiFq
         LLRmQCsHkx5+7+2ewLHHcvZUNX3m9EUK/eGK9H6yyjvpD84WNI2z/h29RkkSHnsJVz0u
         ioZaACbEapFKrhQYPw1tHEys82hqDeXLwE9YNcAncM+Rm8J8FHiff+ZE57RdDLMvxuMU
         RO2rS41KObHDdH90x+LX6yqN6t7G5eqpBzEUjzwroaeySr8T3DWT6hEfrO8gpH993xD6
         3yFOhj6uzg/buohO8t7tMPhrXMsJs6fHz0aiogAzJfozYdKGUpOyCjJ2jIe6Dk96HSDR
         hqpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765915743; x=1766520543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i1bbnR9hzdM9Uf+6FrzBwEhl6E+6kDOhpZpgPAvE7Vg=;
        b=K1da+UbHA+kCvgw4ii+l29mut5pRE9ARb6vi8zmKeBjQF4lgFocTqo1Ei2UCqJjXil
         VdhVN8I6xudzjaIR+jWouAZcY4m74tGLQNZMOJSB1rO5IKx3ZalI7TgfI4jEZnvUN4dS
         1XZanJPF4AP9uo6Ws/6xu3iCR2doO0SgTLk/WD11eGJDPo79K+4gO+vsDzA77z4E0NXq
         ys7hoKjUbMZFv7v6WB5NQuOLJne6dhWgFjto9SD7Ww3FK15Ut8YFdC0EHjkN01NfdzGf
         ghHJIc7TDyDQ22u0hm4nYzmt4T2MzXHhYOYGyPel089+9RDahnSosbNn+tRbOfhK0TV/
         FIRA==
X-Forwarded-Encrypted: i=1; AJvYcCXyiyYESFpbAT7vosiND/4dh3Lz/lBD7IPJQ8TMcJ6xnbHDHJ274l/xZff+x4JlY2jQTPBVh6rkZQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywu1HQRj4D4fAoKN49dYpQgnq9fmjg/4H290Zyjg5q7tZ2P+Ci4
	B1cVv0UZxm7ytUHbR1wy1euLLeMe42S7j+pRn6aBaQ0ZbiWoZVgP0edj
X-Gm-Gg: AY/fxX6+gmXir4wzKpQ8h5dSIv2inR6mOzXi8b8nyk98iAWM1wRwuSa7Mub2z9VCOsS
	dy1Ivba6IIL6v4iRF1mKkdas4zwpb0F+30nbcag1fZKmdQFJ70ZkaMI2DJNMcBmSj2tOY96WzZ3
	35ztg3OL5Nwrg5tEqnJfvYqG2ZUR4oqbW/IUL0kwh0Sa2fWgsbzvFanZkbW7jECjOdOBAelZscA
	PlZcdnXCURAM3jtEsUUyYUo4yjYVInfhuxFY0aei6Q0/9x437SfjzA99lKkupE9XG+HihVUQ6uw
	wqsJp12RjGlxapx8RVLLbqDX3Rf1M8khFLrXVxnojnqUPGd/qG+xqLLMcsbDhdWlIab5khqlxnx
	J5y7loxjLGYtd+qjJqfwvuN89wqM9c4TU6S10r7eAgA1TB9anAnq1bgw5LgU91VBaKKOCJJiVF8
	MxXxb51pwv
X-Google-Smtp-Source: AGHT+IFV1QMqnFEYIhxE0eg69fEl9/ql3eoaZPZV7PrMeB7/xLG89YWVuYGgHgekTUU1ROL/2OouVw==
X-Received: by 2002:a05:6512:3ba2:b0:598:edd4:d68 with SMTP id 2adb3069b0e04-598faa5a3bamr4551753e87.28.1765915742645;
        Tue, 16 Dec 2025 12:09:02 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-599115eb95fsm825534e87.19.2025.12.16.12.09.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Dec 2025 12:09:02 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: audit@vger.kernel.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	io-uring@vger.kernel.org,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mjguzik@gmail.com,
	paul@paul-moore.com,
	torvalds@linux-foundation.org
Subject: Re: [RFC PATCH v3 27/59] do_sys_openat2(): get rid of useless check, switch to CLASS(filename)
Date: Tue, 16 Dec 2025 23:08:58 +0300
Message-ID: <20251216200858.2255839-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251216035518.4037331-28-viro@zeniv.linux.org.uk>
References: <20251216035518.4037331-28-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Al Viro <viro@zeniv.linux.org.uk>:
> do_file_open() will do the right thing is given ERR_PTR() for name...

Maybe you meant "right thing if given"?

-- 
Askar Safin

