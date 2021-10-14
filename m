Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80AF42DAE7
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 15:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbhJNN4q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Oct 2021 09:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhJNN4q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Oct 2021 09:56:46 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD82C061570
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 06:54:41 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id k3so3606910ilu.2
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 06:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B4gbnj241up5KWuUYztyFD31PQiCTxxbrZeu/4BHC78=;
        b=hT4XDTrEcmi3Xk0eUGjG7onqt2qHUNqfN7DbmZ8Kv4DQJtuuDngBR1ud4vFjzRrhT9
         CZwHIuv5kFwNCxb08xGpggI5OKzqla5aOcOC3wxYK5nUzHLeXUUPa0D/XK63j3bRZcc1
         yVip//yaDWEeIvWqgVXI8mZxKWBWHER0kSveYgB4RodBKB9826arG6J487VYfYoUbJU1
         uaeRem6D1G1AfvWNOfQTgOk5hTdQURQrtKw4hz4J91PIKS7U5RZ3Dl0ac1UHgYxKxvih
         42XtTre+FcnM+RUDgMD21HcEAbFzGQ+JfHGg3YS4txBWulbLlLOlu04YsdtPuXSkJ79E
         t4tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B4gbnj241up5KWuUYztyFD31PQiCTxxbrZeu/4BHC78=;
        b=tvn9E6EcaUuvHQWOmANlnGoaNKa3lY+oXQMa+/YeiqLMGGh7P95paxwJyncgVEFvJ0
         1Gpx7+vqxrmQgw424x9EpYpf4kBu/yOaYdcCQh5su9J8k3mS6Miv8X9N2qXqfLBFaKcd
         esH1XzUpVaJO2D9F+LZnI1+PjfyWlreOOh4zIiiCWwVrLJPnoxM4OCGdrrOpWMUGeUJ2
         gXque4Dl7bbjOq1A5yJHO5cgE0BVEMavdysLlaIQnJeT55D04fdVRhvsxsqlVsmBrjYX
         yDWBu8fkajDYwMYohxhxmNgFDbufSyEExym4A46ivgza+ckaDDlh1r6AIBVmSzOA/N5o
         f3VA==
X-Gm-Message-State: AOAM530iC4Zk0t7HhlzXuehwdECz4q9/qJM8PWhtZuJJdvmq6XSIB5MG
        6c/TbZwTHaLpNr128DCfPf5p5BU6dhJgMA==
X-Google-Smtp-Source: ABdhPJwU7q3xiCgatHQqC1n1BbzgPGnhBSm2CvlTBeD5YaQ07HjdhfEFLiU+vP4fiwBURlkSeJCEzA==
X-Received: by 2002:a05:6e02:164d:: with SMTP id v13mr2495130ilu.10.1634219680847;
        Thu, 14 Oct 2021 06:54:40 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id r17sm1207175ioj.43.2021.10.14.06.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 06:54:40 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: Re: (subset) [PATCH 0/2] yet another optimisation for-next
Date:   Thu, 14 Oct 2021 07:54:23 -0600
Message-Id: <163421965638.1286592.11372101723304077588.b4-ty@kernel.dk>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1633817310.git.asml.silence@gmail.com>
References: <cover.1633817310.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 9 Oct 2021 23:14:39 +0100, Pavel Begunkov wrote:
> ./io_uring -d 32 -s 32 -c 32 -b512 -p1 /dev/nullb0
> 
> 3.43 MIOPS -> ~3.6 MIOPS, so getting us another 4-6% for nullblk I/O
> 
> Pavel Begunkov (2):
>   io_uring: optimise io_req_set_rsrc_node()
>   io_uring: optimise ctx referencing
> 
> [...]

Applied, thanks!

[2/2] io_uring: optimise ctx referencing
      commit: c267832ae16edac4a0a829efccf1910edda74b91

Best regards,
-- 
Jens Axboe


