Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54FB362E56A
	for <lists+io-uring@lfdr.de>; Thu, 17 Nov 2022 20:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240412AbiKQTqU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Nov 2022 14:46:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240424AbiKQTqT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Nov 2022 14:46:19 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4506F8A157
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 11:46:18 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id q5so1440983ilt.13
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 11:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rpmdak7qHeRDheaJ5rTrkx9jz12Z06Xol/Zeu4xVqjI=;
        b=cUKjjEiYEXbV+FedcLvNCiPjFUTR36ux0O2m1WsYoUrMzwOUvHRB7CjKFHq6OyKs2l
         JO/7TSFsjd7qZ2p8vWCCV2cmBMvEktNPsKiK+4mEmjwfbaJ+d4Dg2yAcCjKy+B3bPGRv
         f6mmbBPL3MVXFO9dZR54LgPMdDrBnFngnndiVCP0HG6apHRuRR430e7rAlpfKBfAx6As
         9oYcsfcufbZL/C09VZCAjgnK7Gr4CuyMs+Y+oLnS+tqlBDWSv8e0NpdOOVlEtKy0lzv7
         hzuZXnbVRP2Fl1wyIfY+LHk7/9/PPbTEVjaaejaLKEoytiT5SkAzZgDhFqwaVvMRZwBh
         a3Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rpmdak7qHeRDheaJ5rTrkx9jz12Z06Xol/Zeu4xVqjI=;
        b=tOXkOhBEOb8BW7rIQcEuTVkMHbJZY3HGXYou5Wd5fyKafOKXb7VK5IrvIipYQUXlXm
         bImJLZKb2F1aLtjCKA+/AqNh06NcYOR02omXwZ89XyYa2Iv8I5whPkn2pBDjT9cgdJdX
         QXdYUKSK/AfJHb9BwkGxIU/JJHL6fNTaSdy8OvBOHiTa1cuE753tNljdJ9cRqcN3zNTo
         HFG4Ydl/cKq65/SNAXtpGd6Y5x9TfX2PtNBTnnzi4ORPlYecL1ydBFjm+XV429VfkvPo
         zIebl6G7/Lj1gVpPNppGJKUg+1wJ5x8oM5F+EoM/v51ce1BY7eGAmf5VZ53/3GAU4tZM
         Ju1Q==
X-Gm-Message-State: ANoB5pnSH9DT+hTaSzPBQwlFaxBs95xPF6L63q1uFd7JakzR9glxfGy0
        Uabif1iF4+sRWE39mwalvvuWnXq06z2CYw==
X-Google-Smtp-Source: AA0mqf5lia2BzdJbVQQCTsweob9UqylTReUPQy4n5PAhMiHOsJYdA+d/V329ZQ8aQUUqEEbSJBT0SQ==
X-Received: by 2002:a92:dc45:0:b0:300:530d:93f8 with SMTP id x5-20020a92dc45000000b00300530d93f8mr1999224ilq.136.1668714377435;
        Thu, 17 Nov 2022 11:46:17 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id n13-20020a6b590d000000b006ddd85d06c2sm606951iob.55.2022.11.17.11.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 11:46:16 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1668710222.git.asml.silence@gmail.com>
References: <cover.1668710222.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-6.1 0/4] minor poll fixes
Message-Id: <166871437654.150999.16488043354208837402.b4-ty@kernel.dk>
Date:   Thu, 17 Nov 2022 12:46:16 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-28747
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 17 Nov 2022 18:40:13 +0000, Pavel Begunkov wrote:
> First two patches fix poll missing events.
> 3 and 4 fix leaks of multishot apoll requests.
> 
> Pavel Begunkov (4):
>   io_uring: update res mask in io_poll_check_events
>   io_uring: fix tw losing poll events
>   io_uring: fix multishot accept request leaks
>   io_uring: fix multishot recv request leaks
> 
> [...]

Applied, thanks!

[1/4] io_uring: update res mask in io_poll_check_events
      (no commit info)
[2/4] io_uring: fix tw losing poll events
      (no commit info)
[3/4] io_uring: fix multishot accept request leaks
      (no commit info)
[4/4] io_uring: fix multishot recv request leaks
      (no commit info)

Best regards,
-- 
Jens Axboe


