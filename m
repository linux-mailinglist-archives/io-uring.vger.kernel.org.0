Return-Path: <io-uring+bounces-212-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90C22802A29
	for <lists+io-uring@lfdr.de>; Mon,  4 Dec 2023 03:10:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 313AC1F20F1C
	for <lists+io-uring@lfdr.de>; Mon,  4 Dec 2023 02:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E30215A4;
	Mon,  4 Dec 2023 02:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cfYY5WyM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E7FC3
	for <io-uring@vger.kernel.org>; Sun,  3 Dec 2023 18:10:33 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-42549144707so1013901cf.0
        for <io-uring@vger.kernel.org>; Sun, 03 Dec 2023 18:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701655832; x=1702260632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EU0645b6HrnoATY8ZjHr5I1o3N3U7zqEdek89o996s0=;
        b=cfYY5WyMc6NT4yAtz//7rXkV6/MXrBO3bUuZDIllkP8VAH7Fu52SJkzwR3Al7z7tm/
         MrgLNJiac5Umll9dEomPwmnbbIo+QcRm2pJcEHs33oT0u8de8V6hG6CFeT9XtqtHtUXq
         Cd+aGCuNBEzJ50k0LDTznsdVmpcuu9MbVZigTH4Z/5A8vmhWDiJJtVvoQhkQRYb3xjv2
         OXwG4xYwFmvWiuayoWanUan/Q6GHx3sW2RvHhJxhqKcn1KNlta2AZzQt9piLEjEhNwkT
         NldSEI+ifi9dqHz81C0ZLjPFvqqWyh8LxpUyBPtKsN+pdP+o05hcbfSsCstmBugTSe6s
         78Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701655832; x=1702260632;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EU0645b6HrnoATY8ZjHr5I1o3N3U7zqEdek89o996s0=;
        b=p7HHv1XT5GakmDaVKgp49bGbAPQ0oQ/KahkwOLInP89XAIVvdCPh+z7hzfFNC4O9pE
         meb8z3mt3i8hfwTiEwBurSZ+2tLOqzGN4o7Fkyv+FFbgwS3L8mNGJNZzpHlocURxaQyw
         335JD+gyMfotuRQOUTFKTm9QPnH2H9eRjX1eqCtx+DLDKKywgu5CxfTgqL5ymyzUvJrD
         M4UWIdrkq1r7kRitFCppWKf/6/Axyb6l0ijZmECw8CO0AAkfFmal7/Z9Cqm4iEFFL7oj
         rs7hQtTypumybd5LfWfeGz8O1GEuV8RrT83q3kF+6BKyn3A/KiKgfk06W6CZdN9DXJDV
         ljbg==
X-Gm-Message-State: AOJu0YzX6MyMpVH00iwj7wgBR8+Sodrb8lxLo9Cx1NBXVmy0XAODHo49
	5GMLgQ2q1xmtOCCtsegewMY8kA==
X-Google-Smtp-Source: AGHT+IF9cTaNyx/IPnFtNCNPn+DzmLaD9bLSehQwkkJ+YBYDwqNqEg4LTbaOwE3Tr4FTM4TIh/OqgA==
X-Received: by 2002:a05:620a:3720:b0:77d:cabf:6 with SMTP id de32-20020a05620a372000b0077dcabf0006mr13473693qkb.0.1701655832109;
        Sun, 03 Dec 2023 18:10:32 -0800 (PST)
Received: from [127.0.0.1] ([216.250.210.88])
        by smtp.gmail.com with ESMTPSA id az12-20020a05620a170c00b0076ce061f44dsm3833097qkb.25.2023.12.03.18.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Dec 2023 18:10:31 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: jannh@google.com
In-Reply-To: <929d30ff7f0a27793e8b36f398ae12788cf04899.1701617803.git.asml.silence@gmail.com>
References: <929d30ff7f0a27793e8b36f398ae12788cf04899.1701617803.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: fix mutex_unlock with unreferenced ctx
Message-Id: <170165582841.941483.14257006488508512062.b4-ty@kernel.dk>
Date: Sun, 03 Dec 2023 19:10:28 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-7edf1


On Sun, 03 Dec 2023 15:37:53 +0000, Pavel Begunkov wrote:
> Callers of mutex_unlock() have to make sure that the mutex stays alive
> for the whole duration of the function call. For io_uring that means
> that the following pattern is not valid unless we ensure that the
> context outlives the mutex_unlock() call.
> 
> mutex_lock(&ctx->uring_lock);
> req_put(req); // typically via io_req_task_submit()
> mutex_unlock(&ctx->uring_lock);
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix mutex_unlock with unreferenced ctx
      commit: f7b32e785042d2357c5abc23ca6db1b92c91a070

Best regards,
-- 
Jens Axboe




