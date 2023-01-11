Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C79D866608C
	for <lists+io-uring@lfdr.de>; Wed, 11 Jan 2023 17:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbjAKQdH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Jan 2023 11:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239322AbjAKQco (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Jan 2023 11:32:44 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BDD3726F
        for <io-uring@vger.kernel.org>; Wed, 11 Jan 2023 08:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=1Xc1WeN9MG/b8od7dP3CaF7IG1qspVmhOjYJb7ybBQ8=; b=EmCXoedYvoB7D2DJLBR7Joia8U
        u5XXB2gM2gHBc9e88ismq8pCEPWtiypDdQbfG92doFv5GOOm3N5ZchdUgI5emp5GkaY4n4ndXYTX6
        E0cTHHqcNB9dsoxSQNjL+S5r9kdCdrrJbro4ZkMeMu3rLo8vYQtsdOwdElEARZTQTiAj0mq09ZpMP
        VSlB/sE2vbEQHmfC+FiLaoW3oCAdOyv132q5EvPVvrrW9Jx7qJ9gNkHcnr2Z2oOjrwKHghVBMyXe7
        zqeAXcBgCAP8Dg1qTMXmjpzxx8MJeKwOvYgC6mYNqrw2KlOpNP5+x64MvyLnhOrBhLDTTXbaXe0OZ
        vyVhApJzgLfHYoWIrl85+fIvq/OV3QPlvMe+oYkwQ72RFV8g+zuwOceWWpjizUEtRJeRGR91spCLj
        gTZGYLdEiQXw4cbm3qELY86xYtJfeIfqvm+hCUqjtNi88J0cD/ynJ/zQDQ2gIldMd2ghTrmSPmJXc
        ylZ98/0WCf8NqHuRcuh15wXm;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pFe1B-007huL-2w; Wed, 11 Jan 2023 16:32:01 +0000
Message-ID: <b8011ec8-8d43-9b9b-4dcc-53b6cb272354@samba.org>
Date:   Wed, 11 Jan 2023 17:32:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: IOSQE_IO_LINK vs. short send of SOCK_STREAM
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     David Ahern <dsahern@gmail.com>
References: <Y77VIB1s6LurAvBd@T590>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <Y77VIB1s6LurAvBd@T590>
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

Hi Ming,

> Per my understanding, a short send on SOCK_STREAM should terminate the
> remainder of the SQE chain built by IOSQE_IO_LINK.
> 
> But from my observation, this point isn't true when using io_sendmsg or
> io_sendmsg_zc on TCP socket, and the other remainder of the chain still
> can be completed after one short send is found. MSG_WAITALL is off.

This is due to legacy reasons, you need pass MSG_WAITALL explicitly
in order to a retry or an error on a short write...
It should work for send, sendmsg, sendmsg_zc, recv and recvmsg.

For recv and recvmsg MSG_WAITALL also fails the link for MSG_TRUNC and MSG_CTRUNC.

metze

