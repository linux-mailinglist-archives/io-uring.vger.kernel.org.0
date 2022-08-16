Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F19A5962A4
	for <lists+io-uring@lfdr.de>; Tue, 16 Aug 2022 20:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236422AbiHPSqm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Aug 2022 14:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236413AbiHPSqm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Aug 2022 14:46:42 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31B98051E
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 11:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:To:Date:Message-ID:CC;
        bh=rk0Gr+CZc9GSprqsd3Pp83bZ3ZNfERo/3oiNAytZImU=; b=iBVnz9XJTrXa8MY132IRireESj
        uBx6RLOMjbiuNgrzm4us6CzLKaJ20PhLFAASQN78m7hWs7eS1G7yzdYXNEec5BnT8412DUJru+DUE
        vDDqGIbPqJOmO1RSqHwI2+u+JcTsmvSKo7nnQrmnUnC11gDP3BzYF4JaBMjuhqD5OeDyavk3U1YS/
        23WmBAaCKTQq7w7j38SslJbQadU1LUQkpGlDqIh9+fKBWsp8jj27k82x2Ut3b+K3Ywj0XMuI80KJs
        a31h9Q/i1pJeyRJDpDkP+2OhCJozA2NmAtD5QiMP+VnavRzzOtQxdEFvZtiNuLwpdUVqA9eIcbumx
        CJKXG2xfWkLmNWeX5n1QchjAaqs0ZtRpkWK/eHxy5pyUizKVgjPbXV++Znol/cMWcLUJOdbsODZKV
        VfWyGHVTnJu22Rtz19sZLtW1kO/+OJOEeInHVpjtW/jn703b739IhZoBffk6MTcRcFWY7JvklyK3S
        G7BNT8sYo3aWvQEyMIrHQ+jE;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oO1aG-000QaC-Vj; Tue, 16 Aug 2022 18:46:37 +0000
Message-ID: <b56b820d-9b76-8185-197e-4d5fb00b6318@samba.org>
Date:   Tue, 16 Aug 2022 20:46:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Artyom Pavlov <newpavlov@gmail.com>,
        io-uring@vger.kernel.org
References: <b9c90ccb-c269-7c78-8111-1641af29b0eb@gmail.com>
 <e42348ef-af67-d0d5-9651-89ca9e5055de@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: Adding read_exact and write_all OPs?
In-Reply-To: <e42348ef-af67-d0d5-9651-89ca9e5055de@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

>> In application code it's quite common to write/read a whole buffer and
>> only then continue task execution. The traditional approach is to wrap
>> read/write sycall/OP in loop, which is often done as part of a
>> language std. In synchronous context it makes sense because it allows
>> to process things like EINTR. But in asynchronous (event-driven)
>> context I think it makes a bit less sense.
>>
>> What do you think about potential addition of OPs like read_exact and
>> write_all, i.e. OPs which on successful CQE guarantee that an input
>> buffer was processed completely? They would allow to simplify user
>> code and in some cases to significantly reduce ring traffic.
> 
> That may make sense, and there's some precedence there for sockets with
> the WAITALL flags.

I remember we got short reads/writes from some early kernel versions
and had to add a retry in samba.

But don't we already have a retry in current kernels?
At least for the need_complete_io() case?
io_rw_should_reissue() also seem to be related and also handles S_ISREG,
but it's hidden behind CONFIG_BLOCK.

Are there really systems without CONFIG_BLOCK?

metze

