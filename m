Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970985B287F
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 23:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiIHVXh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 17:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiIHVXg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 17:23:36 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E25711C141
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 14:23:35 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id 62so15182270iov.5
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 14:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=q2L6a5c5zapyXUHgpC5A/z47p+sBiU/aJDGkUmFj5BA=;
        b=P6hx+yIOANMpFco2KjdlxRoM0ogaai9IA4WgBi9wWXycAA6P0Ck1zOuIJYNaL1IpZV
         jsrEt7TBaDLv28XOlKEf4AvjPMnkt1kD2my+HIk3986PmspueIO5bcmdTG4Ti6XFYsPY
         AjNZOrzs2wygKqXySsn6GhMFbMyuxnPiHGH1l69M2Nsaq7b+iFDXAPsh/W4nVO3YHb4v
         mYQmvvwd8to6nn7DWcLdXmOvnY1AeY1YUxdDxlQnP4EVTkzIPtPKi0hLjR0IrCixTOYx
         aDwO9ty2nK3azbKFhJcoNPaRoxDwfDpWLWQzlhWRzJDqSQNG2+Mvhwrxw26RiOkrn94/
         YIxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=q2L6a5c5zapyXUHgpC5A/z47p+sBiU/aJDGkUmFj5BA=;
        b=1boPRtSxpDS4si+9SJOY5MILHT3E2RnD8Hl9GnTWnL3R7QWV6fharDf+eJdx6C6+e5
         JBpqi+SVEmpM7kTyyH8c93K5pc6g9vDKSe1zW3W/Z35dfK/sStElgbraYysCNWNwlbTC
         bX80uggmar5SbMTlym5GOVCFzVE05FZHasM3IaHXoeoAxEsYAVhTG5vcZA7rwiXCrbq1
         vQmn14iRdgcHl3RZdyudg7uc4lK2hJmBnan6FolSw6XNdoz7ZIG1wqaRb0qaB52iEXhI
         aT7to99jgX52Z5p5I/3/Y0qPJWvB/8VQAAMVR9/Upi5KgJeQlrqZ8a6UTeXcrk7XXXLh
         UMgA==
X-Gm-Message-State: ACgBeo3Pzmyw6VB7hMxPhi4Ui50jZYUrbD8s+lNF/5GqQDG/ZvmysBNq
        t8POYwh4Kdc1jH10IDI23/QqlLpq7GZ8JQ==
X-Google-Smtp-Source: AA6agR5zSmseWxHp2dnMeXviNq4coyaIJ1jPpIUuGO9HuAqr6yCy89tzwFN6ncUK7YQ40wntW9nY4Q==
X-Received: by 2002:a05:6638:24c3:b0:358:3bf7:dea2 with SMTP id y3-20020a05663824c300b003583bf7dea2mr3105694jat.90.1662672214229;
        Thu, 08 Sep 2022 14:23:34 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c7-20020a023307000000b003583ea83f81sm28093jae.83.2022.09.08.14.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 14:23:33 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc:     Dylan Yudaken <dylany@fb.com>
In-Reply-To: <cover.1662652536.git.asml.silence@gmail.com>
References: <cover.1662652536.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/6] defer tw fixes and other cleanups
Message-Id: <166267221352.889354.15080139695714540575.b4-ty@kernel.dk>
Date:   Thu, 08 Sep 2022 15:23:33 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-65ba7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 8 Sep 2022 16:56:51 +0100, Pavel Begunkov wrote:
> 1-4 fix some defer tw problems, 5-6 are just dropped into the pile.
> 
> note: we intentionally break defer-taskrun test here.
> 
> Pavel Begunkov (6):
>   io_uring: further limit non-owner defer-tw cq waiting
>   io_uring: disallow defer-tw run w/ no submitters
>   io_uring/iopoll: fix unexpected returns
>   io_uring/iopoll: unify tw breaking logic
>   io_uring: add fast path for io_run_local_work()
>   io_uring: remove unused return from io_disarm_next
> 
> [...]

Applied, thanks!

[1/6] io_uring: further limit non-owner defer-tw cq waiting
      commit: 3ecccd114f6030f882e0dbc80d4958a80e0acb1c
[2/6] io_uring: disallow defer-tw run w/ no submitters
      commit: 598ee40dc2602dea491b72d003c505e4e5ce4e36
[3/6] io_uring/iopoll: fix unexpected returns
      commit: 6ccbce854d5d30d328cf4735869c40a13113c89a
[4/6] io_uring/iopoll: unify tw breaking logic
      commit: c701863860cb6bc822ab0c96a351f8cd21c82b26
[5/6] io_uring: add fast path for io_run_local_work()
      commit: 2592425110ebfdc1f8b5d89bb4460d5b028840a6
[6/6] io_uring: remove unused return from io_disarm_next
      commit: 62073e8ffd01ca543eab391e0af9a3194a6e9df3

Best regards,
-- 
Jens Axboe


