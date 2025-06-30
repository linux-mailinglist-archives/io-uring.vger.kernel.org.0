Return-Path: <io-uring+bounces-8532-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EBA7AEE5C8
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 19:29:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E3623BFCF4
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 17:28:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D3BC2BD020;
	Mon, 30 Jun 2025 17:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WuARkc/6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410AF28DEE5
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 17:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751304549; cv=none; b=MjXGsEzi9060bVY/b9SiJZH2ILvlkaAI7ONgFFPVrgVtOBtModyEmPv/IJ3bTTUbTq0OVB6kLxIME/GgusJP1i7bPFSDmUiJG1lkvRVQx86NWlMV6zlkM2WOsY3Xolqd4zBO0oG23sDmtkWSY8+cqb2gBPr/KwjHHJNnB9jrjCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751304549; c=relaxed/simple;
	bh=VLohCoOB3iNO8rkJC45BjYup5b+8fglA3jRClEWRDr8=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=kAtODiJsOqM2kOJMvD2nGSD0cA06t78hY/Yr55T0pceSq/22P3G5F/53HHuIFDXXtKb+fcrVDnKn8DbjiXnEGVXvQh+ufF6MZsQ9ZpxU3ie3VwMgCZIm7IDrQ0J0zhz/xNeglyo7IA8QgxwKeRvVMreC+/b36LlxH1kuGqEamlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WuARkc/6; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-873501d2ca1so41583639f.2
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 10:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751304545; x=1751909345; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u0ayv1WmwB5AUhyPU2czq5mcYL+75TXmg1XMUCJO+8c=;
        b=WuARkc/6ZI4tw/JMcTvs5KJZdu83MgprsYHevuuPW4MGHHaue9+28HCdWj7JJD5RaL
         2inj9wf4W6lhdgZ7Z7jnq+LyfZfBwULVMfT6wvTVOMRsD7mfeVFPRwP+9NPkN/hedyRW
         9s2hxC0pMiYURNC41Coqmeyv3EsKKMfvmclLHBeB5YEalE/DWDKknAhN9aR/e6QzvCbj
         t1M++gwKHZKdozGAiMWwqojbyUmpJB+fw8bxJCW/TL7KnT31QpgImsQcnV6hSfAML+X0
         ny+MofFcEBXuoO0zq95KbiF3oPkDpELHsHnPDrGTKlC8aeQTTCkN2XfeqzFfBw8xnv7K
         tqqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751304545; x=1751909345;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u0ayv1WmwB5AUhyPU2czq5mcYL+75TXmg1XMUCJO+8c=;
        b=jNMaOBktpPIU2cOhs7o7s2C5SJsgvVPhHX5jO56SeBiXvOfBJjidoRDnUPrT+TkDh+
         fckFnoVx3Lb875Tx1zcJuNbZoHAxlLTJwhhlDIu1hRZ7iWzcUtsADfl7c0cR4Em6HiAJ
         HRuHvnRxW7ouHyMpwC2XKIHNXeJ9Y1Gew5HCfvD3oBpnnCMlHcvK1O6o7DST1EfalXLT
         dfpBW2UZdaMeFwAKF09tyUC0zNuYWcTiRC+oGeGSpTYOgNfcCEpD8QofbeBAWTVHEZVh
         RJiQZBIyjRcz2Emf0ALII7wk/OKJF6kSyXVFfO97zvEmaUfLy2kprjFneSEdWrCsVgQj
         bc2g==
X-Gm-Message-State: AOJu0YwtL1oKBaOPU3Eo4FoSesmIJTUDiVOvlTh08G017PlALie42uQm
	HFvm53FwhWCbkt39l/qc4QVYznxe8yfkqTfk5zqvooo25rd0GP0gEI2+JmNaVBN5Smmyz10tH9Y
	Ph0h4
X-Gm-Gg: ASbGncsPegL5QbWqQY5BPdjNCDsU/RucxJVhdUbSyUmcdkjrjiQh8Ekzn9TX9V3tevZ
	hXWXFlzfFdLiXwW4VSfq3IV43HiAF6FgX2r5si+uvaVb9d90zLWzoEkxeyvKxq6xE/d8I6ODNFi
	SMK/2rg4RKpBddxZ6j0hyCZDShiKQZMCKPu0NbkcOPr31ztTaztJIrmfRKC7Uj/fLdt9D5h9QUJ
	HJDzP8AQqLkhWUwHm9wTIKPzdeU0eDVFh83pTuRKbzIOjLhvXV06Q/3srX1THnQamIYfkfj4YaT
	aWveHo2uX+miH2PnJHytkSlH5btnT9Y21klJVU1XBKXQenh9udLDLK5gWUiSrJ5w
X-Google-Smtp-Source: AGHT+IE5bQKF/PAEzn0e5Do7f5HkT2ACnaYQz9mMlFffZcbHlhFK7Lv+6ydyCF5DdZ5Ki3Fdj8aeiQ==
X-Received: by 2002:a05:6602:4019:b0:873:1cc0:ae59 with SMTP id ca18e2360f4ac-876882b752dmr1504228339f.5.1751304545342;
        Mon, 30 Jun 2025 10:29:05 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5036f5a3b99sm494940173.19.2025.06.30.10.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 10:29:04 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1751303417.git.asml.silence@gmail.com>
References: <cover.1751303417.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing v2 0/2] add tx timestamp tests
Message-Id: <175130454463.238692.11609626459332783291.b4-ty@kernel.dk>
Date: Mon, 30 Jun 2025 11:29:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-d7477


On Mon, 30 Jun 2025 18:10:29 +0100, Pavel Begunkov wrote:
> Add definitions / tests test for tx timestamping io_uring API. See
> 
> https://lore.kernel.org/all/cover.1750065793.git.asml.silence@gmail.com/
> 
> Pavel Begunkov (2):
>   Sync io_uring.h with tx timestamp api
>   tests: add a tx timestamp test
> 
> [...]

Applied, thanks!

[1/2] Sync io_uring.h with tx timestamp api
      commit: 2b11d4753496335cec916d3c0a46c181ea79c6b6
[2/2] tests: add a tx timestamp test
      commit: 21224848af24d379d54fbf1bd43a60861fe19f9b

Best regards,
-- 
Jens Axboe




