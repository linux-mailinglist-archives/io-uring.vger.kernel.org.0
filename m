Return-Path: <io-uring+bounces-11037-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D4795CBA6DD
	for <lists+io-uring@lfdr.de>; Sat, 13 Dec 2025 08:52:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 590EA3014AF6
	for <lists+io-uring@lfdr.de>; Sat, 13 Dec 2025 07:52:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 530DA221FD0;
	Sat, 13 Dec 2025 07:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QyRuyN0n"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849543FCC
	for <io-uring@vger.kernel.org>; Sat, 13 Dec 2025 07:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765612373; cv=none; b=qTKmPjzgZHJmoyReyS8Oy9yR0WsoSQcJOnK74YMWhxJVrEm2JUB7RQxZtYQmglcmpqBXTVAbENXpqRwGSILkAvID29H/qC8qxco3La/rcMv2hSEX6oJVPBnmToXeRhnCm8yz3kL3jrT/o5g4mzgTwvRyxe7JVYDo1VBJTcUznoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765612373; c=relaxed/simple;
	bh=blQ0dFBxPxBJ0xPaI1fuKF80stJgtlWWkahEZdpvlgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Onjrt9vQg8KgnPJpIe3tdjeKNRjhLvkWKqLaOH5DyVxWEADYQ99DLlaef7d14Z5uC/sfQUIz0WyK+s6UsizQ6aIbfDNnwdBrmgCnlOBNyBcIZhoqOoSMxrAcNgaCDZDPV321p3KEnXAusdbIfDy09eiUlz76zzwDRI5a6s2/uM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QyRuyN0n; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5957ac0efc2so2336668e87.1
        for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 23:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765612370; x=1766217170; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RX1eqZdD+QdTK0VLe9sMoHAFi5N2Je1usLLZsuCNaCI=;
        b=QyRuyN0n41j8ypeLKiZk1+0f8UzNsxs/lISeIpX1PwVoNPo7GC5y3QWArrbhB1kSTp
         IUmCMD4gaLMfZ04Wh+B5jh43iLVLYllF6yHOpSMsJiu0hmpzf5XTyDj3TsogPFpZkYRK
         ciL/LDxHtNfcGRl4zK+/pq8S49mxtPKBnbCdjWXfBaQRTDLmzTko76zfWiR06oRU9Dgr
         Fq2MMk/h+gU3F0UCS7vCSgjOnS+2KqQ3ukfX8VpK4RSWCcL9rCgqhZeek8lcRMluAOw3
         CAzATwKHsgyJILly6OI9iwNI81GLPxt9MBacFPcE3XrGUreVEghxbx7NNDXkpQ1qJ7pZ
         NxyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765612370; x=1766217170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RX1eqZdD+QdTK0VLe9sMoHAFi5N2Je1usLLZsuCNaCI=;
        b=nf/qiCMmpWIz9B/owtbXAKHdTnBQUCj3L6PyKZCjUXensaMnwa2rKA++ox+mZXcPlC
         J4Cav/TtThFIO5ha4x6o+sDufjUYYd+CvMbYNrhiu77m8Lxh4AD9NJm8MALVpgT9ibde
         4I43TMoawT+oysbohuP13rSSTOVCkvsYMrZVhP+rvFLYzO+UC3ahLkSP0GYn/vGdVTXt
         lLLnfR2QHIo7iSfh+6bOAhUHye1u/qdC06QSgMj0H+6k0HM8p0RksDU+rV/005+SGoEM
         E6LSNc0Ii69+g+RItEwGXFjSUu96UP2u2kkXY2IDOCAjCQXvQYVcJUdpW9vptQSYwFLk
         MGJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjZApf+0xHJoBd+y9GLr8HlnM8QLl2RDe7g+XSrqyaDZG868FxDJdKHJ8xi5ADbN0yv3oZEf4tnA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6A4Q8gsNBV8Ctp4Os3lhUTndRMw1jYLBjCRwZkgp8X9zoGsiY
	z4CZ43FWchfoyPcmk1bxJhPeLfaIPrBnAJ3ps9/cf4EXwEBml0D6JsD7
X-Gm-Gg: AY/fxX7pu/yCamsh8ay//urP/74sOaGXILDHlVXFQJjefUfEuLVErEGXArWDihOD/i9
	cmyNqsruX40p4rtL0QsLKkHgUNC0bjavyWQAyIABfHXxlvQ+v7Zqa7xwGKEggzyVDh75fo19gsU
	SrhZnSiZ2IOjZwi741yOwjAkUll50t5p88y4svYW5BjK2oD9OBrVAMxaw8r9j844NxPmaIwkhc7
	ciBekgDYUSq/HiyTyf0zt7wr0ZJDEB63vLT4C2hgtl7BNy+ycPNS08D2Gus5Zf6LDVNaUaAgyAt
	5wNoGowiwWINGOuXc2oO3usZjlr2nOLUMlcsLXpzMwwO9xt8E9qETc1yWQ+eEuHFMbsCf+1Oibz
	TRgAScPW5Ca2fCBsd1dHvEwjNtp9fNGEwHermwevJVCRR0nJrgJnh1dUmodCzgcl+j+xDIJRGVj
	EVlei5HTUU
X-Google-Smtp-Source: AGHT+IGLUTBvJyYmnDp7a3kK5YSVbxFWtC2bfhu9Ek7QMpiXrPdlK9l+BGA8MOzZApXTp+I0lS0nMA==
X-Received: by 2002:a05:6512:1154:b0:598:8f92:c33f with SMTP id 2adb3069b0e04-598faa81508mr1747835e87.51.1765612369308;
        Fri, 12 Dec 2025 23:52:49 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 38308e7fff4ca-37fdebe5e71sm4485881fa.1.2025.12.12.23.52.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Dec 2025 23:52:48 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: joannelkoong@gmail.com
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	bschubert@ddn.com,
	csander@purestorage.com,
	io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	miklos@szeredi.hu,
	xiaobing.li@samsung.com
Subject: Re: [PATCH v1 30/30] docs: fuse: add io-uring bufring and zero-copy documentation
Date: Sat, 13 Dec 2025 10:52:46 +0300
Message-ID: <20251213075246.164290-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203003526.2889477-31-joannelkoong@gmail.com>
References: <20251203003526.2889477-31-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Joanne Koong <joannelkoong@gmail.com>:
> +  virtual addresses for evey server-kernel interaction

I think you meant "every"

-- 
Askar Safin

