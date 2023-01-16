Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F7866CE42
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 19:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbjAPSEK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 13:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbjAPSDX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 13:03:23 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0DD23C7D
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 09:49:10 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id jn22so30992748plb.13
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 09:49:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1CW2eqf4rBWIDmQmL4T+Y6CdEl25BIvFezsN0Y2yLjw=;
        b=mHuYC16mklvM/gcnAh7w0ZiCqveVomnFRx000mj+ic4nN8MlqUAnPMpr9HCrjn2KEK
         uaVl2JSfLzzGDf1zau4em+oCYgiMQp3QCc/IRgIiPHgKbO29AzoYhP8VPChCoYmC6l9w
         TCG10I3DIxgzgo2POXgK6ZcjjPhq/qJJmqMaULOIE6p4g+Aoi9J/CEvbTwlLUjVZWnqE
         H/ZgMaYlZCmJTPdxt2syVdZXqv0KOFhLyOdee/i//7ANN4hg38dRrMTsZj84JtG/+MPw
         ZMhvsi80FidLX8Jcs/O7ZP7NU5PUQgAyY5vAa7SFWPgx04Z37nGrYGOdh2pkJgol/pyO
         76cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1CW2eqf4rBWIDmQmL4T+Y6CdEl25BIvFezsN0Y2yLjw=;
        b=jTsvBlxkuDt6J20gM2zi/Eh71E8Uy5bmQwh2eC5xeTdizzuB/ruMP+6XWFgI0+Elv4
         EDHHPOYVknlV+yYWKLhDX2wzJ/D+4CgZ3MlfJzwIPtBrTqZq8sDpz89TvHkxYvDMqt2L
         5aKGUJoO8SLgc41H9PPUOkeDdAmtktPJHsW4sxphQpNCaXfhHjH1JRy0gAUBb0xEEp7M
         E3oJivnPQvfeqGO7JykpG/2k7lyE3ZOYl1hRhsPH3vbjjK/OwysoOSiM+5NaVWuLqP1j
         W2PNjVf5h9Q9DgRsdZR3bIfX6I/noqOhrwAGxNW347jigZlOehQ88OmbXQim7/znQvCd
         Rg4g==
X-Gm-Message-State: AFqh2kqG5ZN1DzyFlO0JCt7ojoSRy9DRgACNZCaBG/MeBCsfrWo9sa1A
        l1wZusxrEjo2TdmzA1UuGwdfmp0XOPJ6dNxJ
X-Google-Smtp-Source: AMrXdXsANBZEHonW8CDu+KMmt+dPw5rRcqHKZSogYbPELaxeNfgOGykMnuvmp5ebnv6v4dCKDeYOhg==
X-Received: by 2002:a17:90b:886:b0:221:705a:7e96 with SMTP id bj6-20020a17090b088600b00221705a7e96mr43039pjb.2.1673891350200;
        Mon, 16 Jan 2023 09:49:10 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id js8-20020a17090b148800b002191e769546sm17215427pjb.4.2023.01.16.09.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 09:49:09 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1673886955.git.asml.silence@gmail.com>
References: <cover.1673886955.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 0/3] test lazy poll wq activation
Message-Id: <167389134940.273183.15291346388908180958.b4-ty@kernel.dk>
Date:   Mon, 16 Jan 2023 10:49:09 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-78c63
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Mon, 16 Jan 2023 16:46:06 +0000, Pavel Begunkov wrote:
> Some tests around DEFER_TASKRUN and lazy poll activation, with
> 3/3 specifically testing the feature with disabled.
> 
> Pavel Begunkov (3):
>   tests: refactor poll-many.c
>   tests: test DEFER_TASKRUN in poll-many
>   tests: lazy pollwq activation for disabled rings
> 
> [...]

Applied, thanks!

[1/3] tests: refactor poll-many.c
      commit: cfd00c3bfe18452a06792b7269a59d269f62d637
[2/3] tests: test DEFER_TASKRUN in poll-many
      commit: a2ab37070b9453e43a94b88878ec3a4d780a4ba6
[3/3] tests: lazy pollwq activation for disabled rings
      commit: 849f5ba89b0d1ccf9d825160bf8560ad9901c48b

Best regards,
-- 
Jens Axboe



