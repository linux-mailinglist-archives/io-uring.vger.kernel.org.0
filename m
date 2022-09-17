Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454A15BB7BE
	for <lists+io-uring@lfdr.de>; Sat, 17 Sep 2022 12:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiIQK1S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 17 Sep 2022 06:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiIQK1R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 17 Sep 2022 06:27:17 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254DC27B19
        for <io-uring@vger.kernel.org>; Sat, 17 Sep 2022 03:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=Z6+hyAYL6DHUsiVR8bdzMGnNxPAfgSPn6OA5+4w3q4c=; b=tDUC0eKrt+EsFFoABHSfuOnNh6
        J8tSS8a6DSnzD0Cgl+XytW0d8hfPxVjkhqytVBMdOqPdsegejfi/MZGU87mSi+/InxIlFfPqnp9lp
        ZJ9pIg+G87jQnjxGqGgS40mQ+Df2fgXGF+fTw7QufPA/PjGRUqwE1Vhpf0Bxn66HnJhptKrClXSlx
        GrclmGtXp8OyXVM3yHakAjUAuX2vohsJx7U+8d59gWh3JR2riDhQQ6ZU9Q4J3j7IrsUZXM46cbJ/3
        XxVTMkSTSjXherQGFHeWQzSS5sMIIE+93ElsbYrqIIg0x5sBhWF4Xt11OJUk5hiAJsVdU0xECyTQq
        r1UJbG6NMgR3DSZud6ASKO3gHjsAVJ2Dcl40lczNaA1hQlks7XnF5+W65RrkqDyiSLNmsDsrTE7ou
        5cEQ+HMPVQGgEhjqUkzCezATPs/z+a93vjVnnnMOyxsWZebA8bwFC+wIxNYKTX1efmC6fK3lnR5Bi
        7b3dnLCeis069J7aFtA/FHAs;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oZV2X-000nvL-V9; Sat, 17 Sep 2022 10:27:14 +0000
Message-ID: <7099cb6d-4cfc-8860-0206-0844c4768a0f@samba.org>
Date:   Sat, 17 Sep 2022 12:27:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 1/1] io_uring/net: fix zc fixed buf lifetime
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <dd6406ff8a90887f2b36ed6205dac9fda17c1f35.1663366886.git.asml.silence@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <dd6406ff8a90887f2b36ed6205dac9fda17c1f35.1663366886.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 17.09.22 um 00:22 schrieb Pavel Begunkov:
> Notifications usually outlive requests, so we need to pin buffers with
> it by assigning a rsrc to it instead of the request.
> 
> Fixed: b48c312be05e8 ("io_uring/net: simplify zerocopy send user API")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Looks good to me :-)

metze
