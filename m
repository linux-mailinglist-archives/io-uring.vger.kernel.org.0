Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708F260F2D6
	for <lists+io-uring@lfdr.de>; Thu, 27 Oct 2022 10:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbiJ0Ivm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Oct 2022 04:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233850AbiJ0Ivl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Oct 2022 04:51:41 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B7115D0AA
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 01:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=Ny1ZtnEKGDIJarR+zwt7qDTNSJXBTdS11C3kus5oME4=; b=hKw1YllHDiRfzXfJrRJGkgYATU
        B9nmMXEHi13vi+0UHqVJdORPiImvBjQ2rInf+xTZ71Uws1AC8RtWnA2HmvuYCbcimayvIt0vnpkR/
        LIdaZ24XlkqGXlmWuD1gH+vQRdgztSuLS9hVMlaLniGNFnfPXF0X18392WsZ6Z9iTPD+b+D1bVu33
        e5RTj+Tv/i7WTgRvV//87EAJ/CqYNTx3dwdwVhOCtQYE7BLUu0LtDXNuOQq4R9haPG3YBOUDLdKb/
        kp4Xv7BLyDoZx/uMZNwccNpccn8ngxv88gpl0fYZdVFE3dFZtNVE+UqRFAuvU4zBtkX0I7HtybcTp
        MgQMUSl5HYrN6lbCQU5KVU8y9B/qwpHIbTzHBeNhfsOWiJOiS/bPEZ3UDnqRiC2IcfemXTqQdjPFZ
        CLQiplHmb0cs1HGC2iyFKtywASuNVqP35kk1o/vRllkmsnz4mYSvoBgOTC9pfcNBUHRg/G17x/oJG
        3dDMCU3OQOSVb/67x5jU1v0s;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1onybz-0060P1-7H; Thu, 27 Oct 2022 08:51:39 +0000
Message-ID: <9b42d083-c4d8-aeb6-8b55-99bdb0765faf@samba.org>
Date:   Thu, 27 Oct 2022 10:51:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: Problems replacing epoll with io_uring in tevent
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <c01f72ac-b2f1-0b1c-6757-26769ee071e2@samba.org>
 <949fdb8e-bd12-03dc-05c6-c972f26ec0ec@samba.org>
 <270f3b9a-8fa6-68bf-7c57-277f107167c9@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <270f3b9a-8fa6-68bf-7c57-277f107167c9@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

> No problem - have you been able to test the current repo in general? I want to
> cut a 2.3 release shortly, but since that particular change impacts any kind of
> cqe waiting, would be nice to have a bit more confidence in it.

Is 2.3 designed to be useful for 6.0 or also 6.1?

Maybe wait for IORING_SEND_ZC_REPORT_USAGE to arrive?

metze

