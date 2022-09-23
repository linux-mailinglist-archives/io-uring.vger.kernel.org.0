Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1171E5E8483
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 23:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbiIWVC4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 17:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbiIWVCb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 17:02:31 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125FC1181C1
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 14:01:38 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id j7so774096ilu.7
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 14:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=487Nbsp5fCOeqbA53KmQlw2e+4/ayOhPPLuyUVhEqD4=;
        b=sM6L5bcDmse1dRUqfaKlbGFlzrY6Oe4oP4jrF8ODS1zPVNJiedVBzQ42REXfswaCPX
         hZuicmP4mN9XI+vDC1tLa7UcVgRMmzfRYs1nS5gQ/oTQPHZmjaNOUPTaLo2XbHI3fHRB
         xedlqHBhphNVq2GyvwE3CAHDpt+odGktL2uatsClkUjdT163y9gQ+Ta16awrWHGEjocl
         86HVIT3aVmkSYLPM9mDBU9dUQ/inPyfol/R9W8YC1OJMx/lgWGlh0mBpmekEX7n9qSlW
         /xt0IULNQhixzbwaFSby3oSiUaMx+U6Ocr3hZmd2XQsIHerVWhgR5GS3VUjohwLyzgu2
         xNxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=487Nbsp5fCOeqbA53KmQlw2e+4/ayOhPPLuyUVhEqD4=;
        b=BPXkSGMJ4zXjXuNi5WXkxQC9XrgAxv64ND9L6LdrVpfnJU9ccvVLOISw7R8svnhnkI
         nqvCNWl9suEsXmJorZY0hOygLyNbQKVfmi3yLGpWwTwSyCGmYLT9idyN4D5AH3+KoKP9
         dAlEgcg+dgifoIerLxBCq683LeEayGkHrirvvNYL8tAkPzn/cz4eFJsfrWvPXDpnhPs3
         BxZo42bMF/ovEchAiB5hzUsAif2vTX/u+vblYu011R/TMLzWL9Fhg8iskoP/4ja7xPkl
         ZTCteQGis7sjR+6ch+89e0ZrD+FBQFohsk+tU27x6Aro23hYeUXGObUc2UzbpvlvgBih
         BGgg==
X-Gm-Message-State: ACrzQf2THJjJ9KcbptVxqOvV6iIkNIEfi3WQ8ZfBuaMSWU0ETg3vkvI4
        TJhOsAMU5eMIkoso81eBddIVmVPemfL0Vg==
X-Google-Smtp-Source: AMsMyM4iwZmsOo/q7uFOyDmr6KMOws3x7+E+MhlSBzlnBRIu4dcKZ1vJ9T9dS/CVF1QdcviOipl93w==
X-Received: by 2002:a05:6e02:1bac:b0:2f2:45c2:235c with SMTP id n12-20020a056e021bac00b002f245c2235cmr4884451ili.128.1663966898100;
        Fri, 23 Sep 2022 14:01:38 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b5-20020a92c845000000b002f626355114sm3556130ilq.4.2022.09.23.14.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 14:01:37 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc:     syzbot+4c597a574a3f5a251bda@syzkaller.appspotmail.com,
        Dylan Yudaken <dylany@fb.com>
In-Reply-To: <23ab8346e407ea50b1198a172c8a97e1cf22915b.1663945875.git.asml.silence@gmail.com>
References: <23ab8346e407ea50b1198a172c8a97e1cf22915b.1663945875.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next v2] io_uring/net: fix UAF in io_sendrecv_fail()
Message-Id: <166396689732.501295.6133053172060679848.b4-ty@kernel.dk>
Date:   Fri, 23 Sep 2022 15:01:37 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-355bd
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 23 Sep 2022 16:23:34 +0100, Pavel Begunkov wrote:
> We should not assume anything about ->free_iov just from
> REQ_F_ASYNC_DATA but rather rely on REQ_F_NEED_CLEANUP, as we may
> allocate ->async_data but failed init would leave the field in not
> consistent state. The easiest solution is to remove removing
> REQ_F_NEED_CLEANUP and so ->async_data dealloc from io_sendrecv_fail()
> and let io_send_zc_cleanup() do the job. The catch here is that we also
> need to prevent double notif flushing, just test it for NULL and zero
> where it's needed.
> 
> [...]

Applied, thanks!

[1/1] io_uring/net: fix UAF in io_sendrecv_fail()
      commit: a75155faef4efcb9791f77e2652e29ce8906e05a

Best regards,
-- 
Jens Axboe


