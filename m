Return-Path: <io-uring+bounces-6210-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C1D3A245C1
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2025 00:56:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCCCD1626EE
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 23:56:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C41A11B87D4;
	Fri, 31 Jan 2025 23:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cTyMkNrz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B239199223
	for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 23:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738367814; cv=none; b=T9WLzKJK8XhpHxO/Pxj0PEHaZFeEJUN1zv6m2298h0GeSp0Sure/ZKKINVaa9lLX8fePGk6GwGseOlOiao36lXTKExCL2dR09tHyf5lP2Gswf9GLVotgJ2Ch9n4fMza5kDTRwGC8ToKF2gEW/D3+kukpwa12r2zrHDYvd/O2ebM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738367814; c=relaxed/simple;
	bh=qMBkJc5yq398iYE2JpbTWLNbXgPZiQuIN6Z0RoLZ4Dw=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=iriNKXXXIDUTCUrFnKrK23B4VDdDDKQHJh9Gx3dnDDvXLA2nT+uTJ4mU1yISYbR6wDEmJ4I6+00DuKavwW0dwpmrKlC3eIN/I3/YVKz0/SrfwVk5yuw1eGvpw9pSa7GiKd2V9XijOrBKnogWYYeIDkQJt0UbECTbPP2VCQKsiEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cTyMkNrz; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3cfc8772469so8639375ab.3
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 15:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738367810; x=1738972610; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2dcQ4YaGTN/sQz3dYc2ZayOBMe32ExRyQMrw24aCAFM=;
        b=cTyMkNrz5Fe1vOIu9FzftD9Uw8q1Kqeoenl5O8/djJNbGxsa+f6ICL/2JKbW6cMjJo
         4T25v7XpD4Q/MTYji9qoe0H4flWyJEjKTGfePlFMNu6iR+dWHbViyDdK4snQmX/EMXOD
         tNEsWwMlir0lE1xgeUbZxAbrlGLz/0CfHlXt+qeACKozy48STJpnx8Kk6Mgn9+Kc/Kia
         egaXwz7uAadAcxUeN+KAE98OafRJUbMrh6n+zsVVZ3oHv/CEeg+8E8f6CICWG9poMOKC
         mu6DwvvSG1PnqoAb/2Cz7Emfx/XiVln6/1NcTLms7MHDUlHSFetNYD5rsDFcPDU8wS3T
         iEZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738367810; x=1738972610;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2dcQ4YaGTN/sQz3dYc2ZayOBMe32ExRyQMrw24aCAFM=;
        b=aj6XFFCt+NzXavxaXnGuUeFOuF/SBtid5EImrPaCxdA+H8p+F8d6FjFzSCTY4lt84J
         h3d6xbuddE6UrIS47nLRGGzsdbmv9mjgV7EcFZIDx6KtmojcJeOgDUZZwjraXbEp4HkZ
         YQQ/qZRZKrScJGxo7X2WhZ5ilwwtAul2wrLs9uM5SX+DIDEITdCL2uzDtUUJT0k0Qbbr
         pKE9SsL1VCR0nzUTZt7hldh60BCaGDUTx3WO9yLGbaQ378Smy1yurV9OtQNmOo0ze2N3
         2wQeBzIE4pQJd75o8fue2NrX7fUlFwVPtjiLkLIw+2ctqyUxlgo9kCnCVtlqnm6wZcHz
         7cpA==
X-Gm-Message-State: AOJu0YwEZvvmv84s8GfLekfND24edHYytRtTa70a61wl2p4yf23XwGZG
	sC0y3L9t/aHjo/kI6lD5Uq2zHy1onIBkiMYOVMbagz0+IYB2EtRBSv611uWo3NMaCvTvd9RFRiq
	h
X-Gm-Gg: ASbGncuQjo8Vj5Eu1OuLTl9aJR2l0JV+55e27L7JVFW7hXde2rwxS100TcA9lBTQPpO
	slqhABKSkdB7k9afYZxb/h+wQo06K5OpN3lyFiqWzFy94sv1rSqy54pPSdCjoGYgiFSFWqxYDNg
	SxJpk3jPbfh1iwyiOd6yGalXZDdH7JjDtveRxBwU3gnZmRehesrN3BYgqxtvhWRBt7uAVNcMRX1
	TFz9kEdZMXAKx1EqWzFf/rWuZBrgwz70UWf4Un8T6KK5YTpPycprEn7Jr0OvETnkxMOiunPQxFS
	EODtKZM=
X-Google-Smtp-Source: AGHT+IE5FQXaI1yuRaQql4YCHB/PCnVFcmfOuvHFs/POV4shusOJO2fgjrBNipshFohkjws1Oc7EzA==
X-Received: by 2002:a05:6e02:4814:b0:3cf:bc71:94f5 with SMTP id e9e14a558f8ab-3cffe434637mr114896925ab.22.1738367810602;
        Fri, 31 Jan 2025 15:56:50 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d00a4fd6c1sm11013745ab.2.2025.01.31.15.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 15:56:49 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3a046063902f888f66151f89fa42f84063b9727b.1738343083.git.asml.silence@gmail.com>
References: <3a046063902f888f66151f89fa42f84063b9727b.1738343083.git.asml.silence@gmail.com>
Subject: Re: [PATCH v3 1/1] io_uring: check for iowq alloc_workqueue
 failure
Message-Id: <173836780962.549504.14039825817297526896.b4-ty@kernel.dk>
Date: Fri, 31 Jan 2025 16:56:49 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Fri, 31 Jan 2025 17:28:21 +0000, Pavel Begunkov wrote:
> alloc_workqueue() can fail even during init in io_uring_init(), check
> the result and panic if anything went wrong.
> 
> 

Applied, thanks!

[1/1] io_uring: check for iowq alloc_workqueue failure
      commit: 74c726467895a435b89149204ba0c8b245ba9bb7

Best regards,
-- 
Jens Axboe




