Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC6D6F1D6A
	for <lists+io-uring@lfdr.de>; Fri, 28 Apr 2023 19:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346309AbjD1R2V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Apr 2023 13:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346172AbjD1R2S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Apr 2023 13:28:18 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D142F2735
        for <io-uring@vger.kernel.org>; Fri, 28 Apr 2023 10:28:16 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e9e14a558f8ab-32b625939d4so3845675ab.1
        for <io-uring@vger.kernel.org>; Fri, 28 Apr 2023 10:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682702896; x=1685294896;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mx+u+e8F3tpe9jME3ZkNhf/uGT2LdeSIrgmUdMOCoHA=;
        b=StkHpsTFpc04mYRpir23kIUT3IfSMOjigxosKHgX+gCeWel7dyhRfqGvXbHUZwOaj5
         cOmpDi3mLtJz1AcA9iR3BmwiuJ2G29nre1arFQstFKx8fo7wCREJHYvPPagMXM5Pv67v
         CGQc9H89+myfRH8sV3i5udBtHw1LMoZj4bEJmm6XkLju7wGfcsTSRbQ25G/Yrxq8HNdo
         9k8pTj0NfwdNMyUF7oBvrqgu8uj5CNNJZ0sAJn+Y3KlOC8s4abk9wsZHUojThtZnGUao
         1BI5+xbPnnEDtyZ+OziPsSMtxIFr83qa5KTVmeR23CRHek3oKvSC5oJq2elYhPFhVF5j
         Uxjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682702896; x=1685294896;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mx+u+e8F3tpe9jME3ZkNhf/uGT2LdeSIrgmUdMOCoHA=;
        b=G0FAd6MW3MVPutas74fYAkaXsI3HOohLKzCqfwNxFFFGIXRJm9sIIARK0htGfq5U25
         VhKNqk4BQ4MdwaFNCAn46tWcnplcGucRP2UQJpFCkW8idXXo8nyq09PCHJqCpQAmGavH
         RU6qxvAHrNLBat9lNDtkC8H1Chvq4/gnHx80nWoxfPHXcFoA9R9IwlI6ySndG7UR+Sbl
         qZDpd/p1MzRY6NAl+fF2QtKaq38hd7LYEWlwFbhcZyL2MY/OYnCVNSMAx5tGnvvpNbu7
         9qI39tmpkH/XUWichuSIwnyguBmsSHUzVDg3rStVWvFlaJnaCFiv8KrKlQo59B3TJ0Zo
         bcag==
X-Gm-Message-State: AC+VfDxsBldZE/mJufiEYjq1e2nhv5CHQuvFDPBEHFobJzgKnzc5tulO
        zOD8V2kOIRlFYcErVKaCNa4Jtw==
X-Google-Smtp-Source: ACHHUZ6VVhmsMluENvVdOeusjeeWlsYRSHQORwLpr/F9aC6roaNxN8srB7J+NWD6SEU5RENT5xw02Q==
X-Received: by 2002:a05:6602:1696:b0:760:dfd3:208d with SMTP id s22-20020a056602169600b00760dfd3208dmr4267661iow.0.1682702896169;
        Fri, 28 Apr 2023 10:28:16 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d123-20020a026281000000b00405f36ed05asm6225655jac.55.2023.04.28.10.28.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 10:28:15 -0700 (PDT)
Message-ID: <678232fa-fd02-37b7-3048-a124c4ffdc71@kernel.dk>
Date:   Fri, 28 Apr 2023 11:28:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 0/3] io_uring: Pass the whole sqe to commands
Content-Language: en-US
To:     Breno Leitao <leitao@debian.org>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com
Cc:     leit@fb.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, sagi@grimberg.me, hch@lst.de,
        kbusch@kernel.org, ming.lei@redhat.com
References: <20230421114440.3343473-1-leitao@debian.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230421114440.3343473-1-leitao@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/21/23 5:44?AM, Breno Leitao wrote:
> These three patches prepare for the sock support in the io_uring cmd, as
> described in the following RFC:
> 
> 	https://lore.kernel.org/lkml/20230406144330.1932798-1-leitao@debian.org/
> 
> Since the support linked above depends on other refactors, such as the sock
> ioctl() sock refactor[1], I would like to start integrating patches that have
> consensus and can bring value right now.  This will also reduce the patchset
> size later.
> 
> Regarding to these three patches, they are simple changes that turn
> io_uring cmd subsystem more flexible (by passing the whole SQE to the
> command), and cleaning up an unnecessary compile check.
> 
> These patches were tested by creating a file system and mounting an NVME disk
> using ubdsrv/ublkb0.

Looks mostly good to me, do agree with Christoph's comments on the two
patches. Can you spin a v3? Would be annoying to miss 6.4 with this, as
other things will be built on top of it.

-- 
Jens Axboe

