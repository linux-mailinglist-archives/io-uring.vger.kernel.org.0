Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810407CFE62
	for <lists+io-uring@lfdr.de>; Thu, 19 Oct 2023 17:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346440AbjJSPlz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Oct 2023 11:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346436AbjJSPlv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Oct 2023 11:41:51 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018BD197
        for <io-uring@vger.kernel.org>; Thu, 19 Oct 2023 08:41:43 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-7a66bf80fa3so33304039f.0
        for <io-uring@vger.kernel.org>; Thu, 19 Oct 2023 08:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1697730102; x=1698334902; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5xxv/44z+YoCHFzTUvV/HWGf+cSx/epc2a2ex7I2Rd4=;
        b=0FxvLccpnKQ4ZTnNW+3aF+4ZJhZvUSKTlgj1ozd9/icZi7jnXx9l7EKY6IHTaBKb1E
         0d377NlbXqfYz3zIR7c/YZEbZucVBLRwsCFUxKWDRzHfWSUArN1hlFOJZt8aKzF/Lg5A
         KzxcKTf6WQsrw0s9VAs1AQXgYY1HU5N5GReR6CwgB9s7Q8RxEIUg8D+x+4M3KKS0JbzW
         veL1mJO0rJ/Mr+p+d1rtWYq7aFf6baNJuUZYCUNugBH6vlQLdWMZZzUiTd0wi3hqQRar
         CNum2+4o3OD3wN1Iw73TZC+OXAFg687lXTCfy5vHqnqgzCFEoWMjkySQ11HCnNp3xJTK
         PiYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697730102; x=1698334902;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5xxv/44z+YoCHFzTUvV/HWGf+cSx/epc2a2ex7I2Rd4=;
        b=f6eW7wkqgltG6jnbT5XPbTd2pml8zDvqrzdwDqypegv1L1kdquvaQc4Gav/nM+jrKv
         bB9IDP1Of3vZdpEMtxx2eKXyaeKFr54H5FgnqZsGAY+1ZjzCVniCXq0GYjxo05pR2s3F
         AJwK7kge3QpDKa7ETzn8wY5Pmzc8/dsb1RGsfFhP5c7AGt8jUHC9eyP6uJTzlfoQhqNO
         JLjSFKiOmUz1Tw6kkEoYQvRp1Ui91NeeYwaJMBgM5WdLcGk8CU14GdD1XX9bguZTZCoi
         b1aO+8UTCx9i2jB2GCyAAJZAFwnAMOfBbr5/Nx1jGcJGteT6WPI/IlGuRpg66qgeuox0
         4k7w==
X-Gm-Message-State: AOJu0YwRYfKx62IAaQBMM4nU7f8DHuhXKSpg/x2kYl7OCbO1JL8ai2I2
        jz7rScvDlZsvzphrz5t9HZH8kA==
X-Google-Smtp-Source: AGHT+IFA9Ko8BzzmJvF9/Ll+x8hNvuQTu1RIUoMhlZt65y7Pvfo1T3P3HE1EZUqk9PGPQtsvTZn2lA==
X-Received: by 2002:a5e:db45:0:b0:79f:922b:3809 with SMTP id r5-20020a5edb45000000b0079f922b3809mr2532203iop.1.1697730102564;
        Thu, 19 Oct 2023 08:41:42 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id da19-20020a0566384a5300b0039deb26853csm1992382jab.10.2023.10.19.08.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Oct 2023 08:41:42 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     sdf@google.com, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, martin.lau@linux.dev, krisman@suse.de,
        Breno Leitao <leitao@debian.org>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
In-Reply-To: <20231016134750.1381153-1-leitao@debian.org>
References: <20231016134750.1381153-1-leitao@debian.org>
Subject: Re: [PATCH v7 00/11] io_uring: Initial support for {s,g}etsockopt
 commands
Message-Id: <169773010167.2728246.364592257409613748.b4-ty@kernel.dk>
Date:   Thu, 19 Oct 2023 09:41:41 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-26615
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Mon, 16 Oct 2023 06:47:38 -0700, Breno Leitao wrote:
> This patchset adds support for getsockopt (SOCKET_URING_OP_GETSOCKOPT)
> and setsockopt (SOCKET_URING_OP_SETSOCKOPT) in io_uring commands.
> SOCKET_URING_OP_SETSOCKOPT implements generic case, covering all levels
> and optnames. SOCKET_URING_OP_GETSOCKOPT is limited, for now, to
> SOL_SOCKET level, which seems to be the most common level parameter for
> get/setsockopt(2).
> 
> [...]

Applied, thanks!

[01/11] bpf: Add sockptr support for getsockopt
        commit: 7cb15cc7e081730df3392f136a8789f3d2c3fd66
[02/11] bpf: Add sockptr support for setsockopt
        commit: c028f6e54aa180747e384796760eee3bd78e0891
[03/11] net/socket: Break down __sys_setsockopt
        commit: e70464dcdcddb5128fe7956bf809683824c64de5
[04/11] net/socket: Break down __sys_getsockopt
        commit: 25f82732c8352bd0bec33c5a9989fd46cac5789f
[05/11] io_uring/cmd: Pass compat mode in issue_flags
        commit: 66c87d5639f2f80421b3a01f12dcb7718f996093
[06/11] tools headers: Grab copy of io_uring.h
        commit: c36507ed1a2c2cb05c4a2aad9acb39ca5d7c12fe
[07/11] selftests/net: Extract uring helpers to be reusable
        commit: 11336afdd4141bbbd144b118a8a559b1993dc5d2
[08/11] io_uring/cmd: return -EOPNOTSUPP if net is disabled
        commit: d807234143872e460cdf851f1b2bbda2b427f95d
[09/11] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
        commit: c3199f61b896cdef3664dc12729a2beadf322783
[10/11] io_uring/cmd: Introduce SOCKET_URING_OP_SETSOCKOPT
        commit: 43ad652250d24e9496f4cd6a0d670417807ac9a0
[11/11] selftests/bpf/sockopt: Add io_uring support
        commit: d9710f1d12a99738ff168e252ab8e9ffdeb90ed5

Best regards,
-- 
Jens Axboe



