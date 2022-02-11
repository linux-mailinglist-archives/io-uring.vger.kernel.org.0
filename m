Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4AF4B2704
	for <lists+io-uring@lfdr.de>; Fri, 11 Feb 2022 14:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344229AbiBKNYU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Feb 2022 08:24:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiBKNYT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Feb 2022 08:24:19 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE547CCF
        for <io-uring@vger.kernel.org>; Fri, 11 Feb 2022 05:24:18 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id h7-20020a17090a648700b001b927560c2bso7650118pjj.1
        for <io-uring@vger.kernel.org>; Fri, 11 Feb 2022 05:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=f0Fqv0bzjFszIvvUAYWw2+6kT8bby7TTzSPdzg4sLUk=;
        b=Nc1J7qQsJ5lN0gl2mCSiyQbwLxaid+TjM4CKQxk6Cf5vjQ6gi9mrnWc6LNrSc7aWqO
         AZSCN78OBiJa5L4N6lszjiBB+TZ+S1dlkQsQcMU6dpYy4yIiUF09ZrZH9oNotc1ekUlx
         3iVYoiIAcrxfOrvi9ICK74/BPk3R3gJE864ANAv2SdLvyOZkoUlDrXFN3DlO6nKkx4DS
         jP3aWbXY8gcefvSLNxVKFJslqMJ5KY4eDFk3q0yQT2Gr3y67Yf02Uq2oWTEa2w2y35gy
         oyKEBdp4yD9CCmAzoamDdHaNBaRuK4XO2G+KGLiiwKA0bVThIv207BqyzRuR6Mm6YT/3
         ez1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f0Fqv0bzjFszIvvUAYWw2+6kT8bby7TTzSPdzg4sLUk=;
        b=SKkn/960Hp47LJRDE6VN9DcZuP2ylOOLV1yHVKEtyEwFh1XVfmElZSCmY5M8VApbuO
         xlE6WvTLSGr47/PPdwLKs3WthOE7hyJPZ/oqnOMPMtSnHpDov7PJ+l8ppAfl9b+pKN6I
         27UhmcsYyvJhAbphMiq4hNzrgGEOkTvdhpZK8fkx8SugehIKgYfim7S9ntILS+YIGBSl
         Pwpgg8jjySv70B7cnXRxKPwO3TQvWo7fMp2Deez0AuisyILrKM2wU0DaPHSPP4ptLkdy
         vj1pF/YwDm+vW5RZYEet4zHyCyLSwEfZjAynn602b6r5E5PS1D40GZ9MS96dPJ43nmwq
         BNsw==
X-Gm-Message-State: AOAM530yxpHSx/pOnXpHHUAcFknqYzmsQvsSL1gCtGvdqXb5BTfm2jjV
        I7Jwg3XEIePtpete48XJadOgqw==
X-Google-Smtp-Source: ABdhPJzK2XUVwYEzIxK7kyMOxfYcu9Ot/TBK7K2adSoNhKewYU5KYOdn5DxEl72sB6jd1gpTdGqm8Q==
X-Received: by 2002:a17:902:bd03:: with SMTP id p3mr1610578pls.50.1644585858331;
        Fri, 11 Feb 2022 05:24:18 -0800 (PST)
Received: from [192.168.1.116] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f30sm11884656pgf.7.2022.02.11.05.24.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 05:24:17 -0800 (PST)
Subject: Re: [syzbot] possible deadlock in io_poll_double_wake (3)
To:     syzbot <syzbot+e654d4e15e6b3b9deb53@syzkaller.appspotmail.com>,
        alaaemadhossney.ae@gmail.com, asml.silence@gmail.com,
        dvyukov@google.com, hdanton@sina.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000098f75305d7ba7942@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6c143b3f-c801-1906-27d1-be876272b1a0@kernel.dk>
Date:   Fri, 11 Feb 2022 06:24:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000098f75305d7ba7942@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz fix: io_uring: poll rework

-- 
Jens Axboe

