Return-Path: <io-uring+bounces-9710-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A6DD8B5218F
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 22:07:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6CFC97AD99C
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 20:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19AD62EE261;
	Wed, 10 Sep 2025 20:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="PEdbnMtG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CB92EDD58
	for <io-uring@vger.kernel.org>; Wed, 10 Sep 2025 20:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757534824; cv=none; b=kWu7FBF4Oll7L454DbiMR46eJ3Lm71O1Y8/rrve0OMNH+J4PqnnvBpG198E6IL7EKw8mG5dWp4zDYqrGBsocGAKO6Ei1OHKefw12g+7nwtHbjiD3HGj7fTMMwBKFj6/yomdh1bWQNDSojU4UqcK7qhNGj9Gt2UObQZSumP1TGpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757534824; c=relaxed/simple;
	bh=IxnBabp8sPnSRkmn54GGrojen4tXZIVrlZ6r6BkmXIc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iulYrw4O7x4NANqIz27ZwGLia/hFjBFXxuVC9QfKm9H6ewc5uZcuEfOExZg9KNNmQe4NtIM7xRB3qATrmn6cYKH+mV5eYbV1+5C5mo6BJP5Ciy7vNn13wmT6nL1cXq8IKoHW01gLhIUWBctg1gz3euHAQcAQ9FeAEg80TXe2bpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=PEdbnMtG; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-24498e93b8fso13947425ad.3
        for <io-uring@vger.kernel.org>; Wed, 10 Sep 2025 13:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1757534821; x=1758139621; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IxnBabp8sPnSRkmn54GGrojen4tXZIVrlZ6r6BkmXIc=;
        b=PEdbnMtGaEQpkP+nAc/VfCAt978rZw3wfmYaWLgw3r3kiNgfLLF1GXytMbFiwCrZo1
         +0GN/LAuIMydJYIXernihMrry3mJR1DHqrBNJGI1H0Za0FToiXWRvRdwi083hiJUx+rn
         qtks405W3XrL7zAHeETiGjXLZmMlvRewtUrUUOLOmE+//QzlZ47KUNxss67ZxTRfJ1tV
         vpMLFZnM66tfakr+/BM7kNhxYuApWC9gFkKGhSNfQTEg2OJrOr+z9cfOwzYGTI2OS+tN
         3az/MK8r0p2K815WiEhzHEIhfZfpmCbmgceER/hGpDtFlpgTeBl2xDoSn2aAFhMDpoTB
         GKAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757534821; x=1758139621;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IxnBabp8sPnSRkmn54GGrojen4tXZIVrlZ6r6BkmXIc=;
        b=Tf9POP2iY1V/IK09ABimQx6d+DvnUEBZLG087XLa2WyEY6EmbCVPc45R4z3lwjdtrb
         af1ft9Yz8ay7JR9mGM7O9zKBhVN+dkA8srANi4rsT2Gs+kAt3EHI0AJI3JrVudW8V95K
         +hhTx3TI2fvtTWz13ZvmkbkW3cAD8y6PpndveefeyhS98yVoLSO62UGdva/nUJUSxj5q
         +MHue5kjtxZIvNhSBOaBfnSKr2p+N4mkSpuI4pOLtj75Dk4cf7S5nUBAac/tqS9JYQTs
         ZM+G1UTa3SfGlCpxD2HFHr6feuzq5BIsSZYFrub/friOF6rMN6r+2sJzXUlbQ1a5CGKV
         hNvQ==
X-Gm-Message-State: AOJu0Yw0V8FwUIQzgmSQrOrm4coMRW4GSSG50JtU/jD1wKcnNk2n2L0m
	24W/2M9xIwenVgvgIeNHoug/mFT/u0fyBm2HG1ZMqpYnRwJSJORDLTAbr/rGNbwZiRXXa0cYWrP
	N5kUFe4fCkn5Gs6DiC6j/rqRVjJtSBLCUiBBNM4XnL46qq7i/mTj2/5RD8w==
X-Gm-Gg: ASbGncuFEonTp+stz8AZsqqUgd9+hzKwBrztl6qB7enl6qnR4FsqRG/5c8ySFtWa80X
	4/O3zSE5Uwo4Q/5TrsR+q7TgfTZmWU+ScBBAxMY/9mARI/Pe8kabbrJoPifzeFmut4PxaXWJeBk
	smHNOkRrxGa/jl87OK+tNUeLkDF94RTUBe2beckMc4q1sbGmVFUWr53mnPj+0kPEIrxjnc4Cnud
	DXherGHtoqCGq/Yemk=
X-Google-Smtp-Source: AGHT+IHotvucrD7Tt1zEGWMpWO4NHNBvAG6Jozuq85LTn+uJGJwX4M9NLgZ6hrHMkgXJolvxw0M+oETaF/GK+o87pdo=
X-Received: by 2002:a17:903:18c:b0:24c:cc2c:9da5 with SMTP id
 d9443c01a7336-25173ea24a3mr120113515ad.6.1757534821514; Wed, 10 Sep 2025
 13:07:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <f2ab91d9-0d62-4bae-8efc-aece69d407d7@kernel.dk>
In-Reply-To: <f2ab91d9-0d62-4bae-8efc-aece69d407d7@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 10 Sep 2025 11:06:25 -0700
X-Gm-Features: Ac12FXwoccl6DLoCxtZnfPoWx0v-GxsCGcjP6uMR2WNerV5ftB4cQ64Ek2l-mcY
Message-ID: <CADUfDZqG6pAfHDJHn5othpGRG1pcv9v=HxrS+gn5v+gzDWwd3Q@mail.gmail.com>
Subject: Re: [PATCH for-next] io_uring: correct size of overflow CQE calculation
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2025 at 9:42=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> If a 32b CQE is required, don't double the size of the overflow struct,
> just add the size of the io_uring_cqe addition that is needed. This
> avoids allocating too much memory, as the io_overflow_cqe size includes
> the list member required to queue them too.
>
> Fixes: e26dca67fde1 ("io_uring: add support for IORING_SETUP_CQE_MIXED")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

