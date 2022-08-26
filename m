Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD5C5A2F52
	for <lists+io-uring@lfdr.de>; Fri, 26 Aug 2022 20:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345305AbiHZSr0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Aug 2022 14:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345323AbiHZSqc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Aug 2022 14:46:32 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BFFD25CA
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 11:42:55 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id x14-20020a17090a8a8e00b001fb61a71d99so8893449pjn.2
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 11:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc;
        bh=H9ry820hgt63SdHx75zNbprqxwxgnWLZzPKHEI7n6d0=;
        b=4+X3fkwt9b+i94Em3iEu6AtW/UBX3vfOZCMd5jFpEA5qYsOqHEG4OlUFaELp79ia5B
         Cec2tdjkwhBPqHhMUQPowU67L4Iq3V3TddTg+exSDSmyKwHxnP+nmrRZ/fkAMD6OI3Zw
         YOptYkhQYiA/evXff76zA+AROHdLuyEJ6D49z3oJ6m86hJHLQLcGThpEQ3S8Yz/WjoIu
         3HiBxwdF+BMTOLUXtQmoFk5jT/LbIwR1CZuUIcnkqNEsWBXjEw8Rqp7SNd3iap5NWs/B
         U0poFe/cXKTzsx5ZUaXh6YBD/KbQwqlNWLB/2TaXMg52SLgrMZU2kbqI/hHRT7pERLv1
         7ZWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc;
        bh=H9ry820hgt63SdHx75zNbprqxwxgnWLZzPKHEI7n6d0=;
        b=0OhZtwImEwnmHCPI/IpNp8/aB7k9wOoD/pRzZfDVG897n9pBSTah3rw4ISfRGFQtMx
         s0f71MO2A7bUk0tAYSoQ0jCqdwQyP9505CfF+xSjZwTS110D4iQtAYHNMHDq+eh81a7H
         c8iiwI1lT6XKEDKLJLw08Z5mmhCi9VMlJ/B1t7/XpEZItEN/tYARP10a60XwsEmxaelG
         1WqTHNuidgjj9CcWOVLXfa3dfBgTlLuZYa3i+dkQ9WC84Mz5ZTmGdMk9s7PGFVOQ83yH
         GH38OmZCxYqohh0EjvjP2vlx9EfaFrEDwStWbTy23P+5rcsHimcXdp/DzxbREt+ZHhEn
         WaIA==
X-Gm-Message-State: ACgBeo34FvEgIpao/m656wWhCcupckOc4vjCTY9Jqt9aW0vmr57b+tTB
        k6iWsifipNWxsoGse0h8A4Jt90j21JQCUQ==
X-Google-Smtp-Source: AA6agR6BPCBgxZA78z5vbqDAteQSCkL1jm0CYwRriWciq2ULTA8UrqSLv+wX0X1r+/qW///OPmseqw==
X-Received: by 2002:a17:903:1250:b0:172:614b:5f01 with SMTP id u16-20020a170903125000b00172614b5f01mr4975355plh.103.1661539374875;
        Fri, 26 Aug 2022 11:42:54 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l16-20020a170902f69000b0016f196209c9sm1968500plg.123.2022.08.26.11.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 11:42:54 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <0bc0d5179c665b4ef5c328377c84c7a1f298467e.1661530037.git.asml.silence@gmail.com>
References: <0bc0d5179c665b4ef5c328377c84c7a1f298467e.1661530037.git.asml.silence@gmail.com>
Subject: Re: [RESEND for-5.20] io_uring/net: fix overexcessive retries
Message-Id: <166153937413.3329.15080755599100758844.b4-ty@kernel.dk>
Date:   Fri, 26 Aug 2022 12:42:54 -0600
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

On Fri, 26 Aug 2022 17:15:47 +0100, Pavel Begunkov wrote:
> Length parameter of io_sg_from_iter() can be smaller than the iterator's
> size, as it's with TCP, so when we set from->count at the end of the
> function we truncate the iterator forcing TCP to return preliminary with
> a short send. It affects zerocopy sends with large payload sizes and
> leads to retries and possible request failures.
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring/net: fix overexcessive retries
      (no commit info)

Best regards,
-- 
Jens Axboe


