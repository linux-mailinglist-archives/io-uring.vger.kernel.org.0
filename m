Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD45562427
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 22:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236777AbiF3UdB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 16:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236456AbiF3Uc7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 16:32:59 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA81313AD
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 13:32:56 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id c6-20020a17090abf0600b001eee794a478so4317583pjs.1
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 13:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=FSOXo30Uq9BCNVmuAsi5w5C8gOosb3t9WRfMVCrT6IQ=;
        b=71OaPdRgzLBTFUshicbPVMG4LFaecqp39w7V47CfMj+0gY4RebWxjQKLK0o1lonnjr
         IoAMSLIWtQD5z7lRwT5WsJnZkVxgqw8urqB2CkcXtj5r7PxFc4TRxG1ra6n1A44W5SZt
         u++p3JA2pefoNjsXomGzNSTArkokqVSIIWO2FjZkv6yzOiJr4DRTnrlrwBcexAPYyBx8
         X4w38cbLY5T7ozhjVVvtz0HjacsTUDNch7stI7DOeuoGvcUiSZyChBTe5kAc1VXRnXZC
         g6vUZae+vpwFvl4X1eemIiAuQhGwbuci0/1I2yA+X0LB+1yC5jZyNjnvEQU73CRNIxQI
         0NiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=FSOXo30Uq9BCNVmuAsi5w5C8gOosb3t9WRfMVCrT6IQ=;
        b=Iik645+DKSREcidKl3wrhnOmj6cl3pkixIq9aq00cLFdpHxnuWQVZtnKdXL+5w2hE8
         uYzhAqdMUaC0xED0rJHDGtVVNCrjyKub8DLOZIQ+FAG1u5bFT3w8d7SW9lPKqkIQD8xR
         vUQHjDEKxwbivRy3KKcZI/hgFbOt+bljyq2YsfMlgU5wg6DsuRX6QIvukCOyQUvXzSxb
         7yCt07ESJURaz8oHuNxt93AYVOSaSXcMS0JmIqVXgSEPutgz5irAvF4ZQh5C/Ir9H+l3
         f6+KAxlGl6ErsWUFDIWfmIrchz1w9FW/PuXrkbRK3YOIJqtLKMjE1COiy5bZvDwdI9u/
         Hlww==
X-Gm-Message-State: AJIora/q5Mvj0WJiBHEqn5vpTI7nSSoYr6Hpdc+pXIQpiJi4tUeV0M6E
        lbcUz+ndFeDXVr69ZsSje8s7Pw==
X-Google-Smtp-Source: AGRyM1u3r0jLkJPWYEWyhol/kypao7RlzkqpzAuN75e/SjlpAHz+TJeGBAXqSJqhLeP3Be+jqUbY/A==
X-Received: by 2002:a17:90b:390e:b0:1ed:1133:8711 with SMTP id ob14-20020a17090b390e00b001ed11338711mr11904632pjb.90.1656621175704;
        Thu, 30 Jun 2022 13:32:55 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id kx10-20020a17090b228a00b001ec9ae91e30sm2475038pjb.12.2022.06.30.13.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 13:32:55 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, dylany@fb.com, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Kernel-team@fb.com
In-Reply-To: <20220630091231.1456789-1-dylany@fb.com>
References: <20220630091231.1456789-1-dylany@fb.com>
Subject: Re: [PATCH v2 for-next 00/12] io_uring: multishot recv
Message-Id: <165662117486.56180.16557557417345255423.b4-ty@kernel.dk>
Date:   Thu, 30 Jun 2022 14:32:54 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 30 Jun 2022 02:12:19 -0700, Dylan Yudaken wrote:
> This series adds support for multishot recv/recvmsg to io_uring.
> 
> The idea is that generally socket applications will be continually
> enqueuing a new recv() when the previous one completes. This can be
> improved on by allowing the application to queue a multishot receive,
> which will post completions as and when data is available. It uses the
> provided buffers feature to receive new data into a pool provided by
> the application.
> 
> [...]

Applied, thanks!

[01/12] io_uring: allow 0 length for buffer select
        (no commit info)
[02/12] io_uring: restore bgid in io_put_kbuf
        (no commit info)
[03/12] io_uring: allow iov_len = 0 for recvmsg and buffer select
        (no commit info)
[04/12] io_uring: recycle buffers on error
        (no commit info)
[05/12] io_uring: clean up io_poll_check_events return values
        (no commit info)
[06/12] io_uring: add IOU_STOP_MULTISHOT return code
        (no commit info)
[07/12] io_uring: add allow_overflow to io_post_aux_cqe
        (no commit info)
[08/12] io_uring: fix multishot poll on overflow
        (no commit info)
[09/12] io_uring: fix multishot accept ordering
        (no commit info)
[10/12] io_uring: multishot recv
        (no commit info)
[11/12] io_uring: fix io_uring_cqe_overflow trace format
        (no commit info)
[12/12] io_uring: only trace one of complete or overflow
        (no commit info)

Best regards,
-- 
Jens Axboe


