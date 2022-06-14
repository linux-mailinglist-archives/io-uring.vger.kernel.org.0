Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8DF54B74A
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 19:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237402AbiFNRDD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 13:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356984AbiFNRCt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 13:02:49 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2E7101F7
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 10:02:44 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 129so9062451pgc.2
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 10:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=OEIFCNRsB0Hou8mfvj47gpRH3Ek6+1a46PkWJYDiUpc=;
        b=kp5cmLHQBmGggdBR05ZJhihHwROJQNLG/Kb3A8xi/y3oYamcilA5Az5xQqM4cEW759
         +yl8jlpjJOOwNFstrXcuuQyX/r4Ge0i1lJm1zB41FmjOVfVxsfNavQydfKZIX8GQ1tPj
         uYLXuct4qmyG0AGODvoxZF7iqNY0U5Wt5x1SMsib9kmh0NcDOr956tJzT+goZwhzHVIO
         NXI5aZfCwkPmO9wVbQUCYFOcJ5yDmCsM5rGd6R3dC1lOot9QzdMC5ZsMZGfdjdYPY4y2
         qSSOH37FO6n5XcxKDnJuUsyatRvL82L+YkxSucwF3AavbdQV0zBrQWP5H7M0mKJ5D1MI
         H45Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=OEIFCNRsB0Hou8mfvj47gpRH3Ek6+1a46PkWJYDiUpc=;
        b=6xZhPRby+JumIWuyzWbwxUhH1+QwYFm6/1fXwQL5htPlOMFjo7jml/7yNYonpUijNM
         g4UxARzojkiIXi+kg0jjnl3vsKEQK9TJM+bSDC01DBWvUttpfn4COH3Xr3UfpWFVedHd
         WBgeTvxQWxKqcXPxWQj4eLp/i2oXUst8W8xCPm1w65YpFQbi0ZaDV9zJMjTQDoQQ6J2j
         qK8DjB9VydtAGSzaS8qY5BKmi6uyPo0LSROQ4N3xpgvU0NXDQkLqkvdxI7alu6KdfdmX
         9kBcFV/CK69U43Wl0Be0gvCI3dXj6+sk6oIB5RFW9UQ0vEanQLq2AObzcfYR9DbVT7Dd
         8Aog==
X-Gm-Message-State: AOAM530nwvEsiPgAiWLhus+1sati5DNi3FIGI+xIYV936vBr9mj9p8PO
        WglD3/sqkJkQgwWR7y4THcHrC0ow1NkyHQ==
X-Google-Smtp-Source: ABdhPJx3+psxE27xQaFC6os0A2VMa+gY3Jr9MVGFDLo+uiGFdrXWzrZkAP6Wax1HrPMRSbHSIjiMng==
X-Received: by 2002:a63:9752:0:b0:3c6:5a7a:5bd6 with SMTP id d18-20020a639752000000b003c65a7a5bd6mr5417427pgo.390.1655226163581;
        Tue, 14 Jun 2022 10:02:43 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h3-20020a63b003000000b004087f361074sm4872393pgf.43.2022.06.14.10.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 10:02:42 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, hao.xu@linux.dev
Cc:     asml.silence@gmail.com
In-Reply-To: <20220613112231.998738-1-hao.xu@linux.dev>
References: <20220613112231.998738-1-hao.xu@linux.dev>
Subject: Re: [PATCH] io_uring: remove duplicate cqe skip check
Message-Id: <165522616223.252805.4800602703171839771.b4-ty@kernel.dk>
Date:   Tue, 14 Jun 2022 11:02:42 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 13 Jun 2022 19:22:31 +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Remove duplicate cqe skip check in __io_fill_cqe32_req()
> 
> 

Applied, thanks!

[1/1] io_uring: remove duplicate cqe skip check
      (no commit info)

Best regards,
-- 
Jens Axboe


