Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58E45933E6
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 19:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbiHORMk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 13:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiHORMi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 13:12:38 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB0B27149
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 10:12:37 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id i77so2807381ioa.7
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 10:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc;
        bh=kkSj5Jae9AQm3Rql399Zc/74DJ28jNr08GpDVl+RgGM=;
        b=betjM5PgQQL1CyvRo1AKaifgr+n1AIRjdzcMHFujsxwnwBtPVEBGAH4WJkF4nb54SX
         aZPLHCM+kfKob/1D23RRaqlYAPv37ZpLmgINdRG/cFjRQ95pEnX9maXFFieP1AB9B8qs
         E0Q3oGrRoT4rilGSR03l6Fi2PlsaEpKhAeYBaaMMocLlEk64BNbEA2Pabzcc8Iq+1WmA
         VDz0FfnA78RNB2ANA5gxQM3cWlg1luPxPc7tDisJFo8x9G7wbOr6qPD7kiZYKTJqaApL
         hkiJzV59c2HT+9taFa3y5UA/e1qix9dobAiekN4cUiGj2oSyLqpheWCxkYn1Wq38ebVi
         fiOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc;
        bh=kkSj5Jae9AQm3Rql399Zc/74DJ28jNr08GpDVl+RgGM=;
        b=EcRnmfYu1Z66ZZJTcJ1EIb0DRsRJ2pPrs86MT7Yoh23X2Xx/TObqXTkkvQmBJuR/zU
         is+KEYwiDwAVmywatOTJYT9z5lR190gcXoLrTXybKZoYyC/6hGHg9W2U/GBb0cMB9C6+
         izWe3+vVkQWRyBOxBDyDRCeGjlnL4SRpa1Rr0LUJVD8MxFiEb40XpC3eQPYCT9HeppPl
         cVeYqx0jl/SqwQJr5Et8hItsz3rAmRC4+U9B+YyFc6ew1g/AOjrdDmWFBurvciyFdmlH
         Eu7Iww9Va9Y5B9Qi12Xs+HgzOljzgUelHc9Amu5VZKALgkhaKEtif/VHfeOKk3WsiNfh
         OTXw==
X-Gm-Message-State: ACgBeo1od3NDcVi4sI/mum5pFZqSBpQkZ1Jzy+IAkmFyQ/iqa/Ulquu+
        UYUnaLG1jt/JrxtrCAqsLbX25DJ4P8ua8A==
X-Google-Smtp-Source: AA6agR7z9YRrDJD7eISQbhF8TlvHeCyjSh5UEYUWbGtpnR0in/1OFwV+amYJU9mL6Xz/qpoIWFESnA==
X-Received: by 2002:a02:c845:0:b0:345:6dfc:758a with SMTP id r5-20020a02c845000000b003456dfc758amr3134609jao.215.1660583556729;
        Mon, 15 Aug 2022 10:12:36 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h21-20020a0566380f9500b003434b40289dsm3498172jal.165.2022.08.15.10.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 10:12:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     dylany@fb.com, asml.silence@gmail.com
Cc:     Kernel-team@fb.com, io-uring@vger.kernel.org
In-Reply-To: <20220815170914.3094167-1-dylany@fb.com>
References: <20220815170914.3094167-1-dylany@fb.com>
Subject: Re: [PATCH liburing] handle buffered writes in read-write test
Message-Id: <166058355583.2374707.11623491940402389484.b4-ty@kernel.dk>
Date:   Mon, 15 Aug 2022 11:12:35 -0600
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

On Mon, 15 Aug 2022 10:09:14 -0700, Dylan Yudaken wrote:
> When buffered writes are used then two things change:
> 1 - signals will propogate to the submit() call (as they would be
> effectively ignored when going async)
> 2 - CQE ordering will change
> 
> Fix the read-write for both of these cases by ignoring the signal and
> handling CQE ordering.
> 
> [...]

Applied, thanks!

[1/1] handle buffered writes in read-write test
      commit: 9adc7ddb158e773c48e25aa1fab7f9f6912a458e

Best regards,
-- 
Jens Axboe


