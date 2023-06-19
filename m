Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B5973565E
	for <lists+io-uring@lfdr.de>; Mon, 19 Jun 2023 14:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjFSMDy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Jun 2023 08:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjFSMDx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Jun 2023 08:03:53 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD86123
        for <io-uring@vger.kernel.org>; Mon, 19 Jun 2023 05:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=zAsiXqFPmYi/49Hayz26a+kBw14I7FqPzVcXtBGDsIk=; b=hH/RhcXkw/YjGTsc+lCvjaUgn4
        6ptmMsfHxzG72IPpokdp5m45Dt6Dlo5gBbWvySS/WRx2Bel7ZEuUxxL6eIHJD/IHx1g8uho08LzPv
        x1fd+4DZuEwTybgxihmggPGQ1/RlQD53h/F2SS9RQbI8IpPTKI+bqJiKA1dRKkYvqOt8AELWNTBAS
        9pxV5hvFmUVglUsJei+0XTBLGGnip8cG3dcX/m1YaiLDjLLdyBtPawM1CphlqYRU7wGZS+DOJJKqj
        I59KKP0BIXPzyGAY+APWZQpm/o6T9r+5ZAMl50+s9DEwXyI8X4AYT8NGWfMnbAbGNP3taWksfdVM6
        SbyM6nU/n7WRyiRBRwNSkOMQ+dgNS3pZKdHQYzX0yeZozsdCI6er8PHRofuFhlm1LKaUmMVtzNdjd
        rqRdZNOpMECO1dvZBxb96glZNbjR2aNWbhcYBseYmOQhYOFmrUp4dyUGw3c9Ru3crxwSWPKkGy83B
        2MHVWP4I+O8lnp8UwgbaOYrV;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qBDbp-0031ue-25;
        Mon, 19 Jun 2023 12:03:49 +0000
Message-ID: <370541a6-1c63-6cba-83b0-246b0236eff3@samba.org>
Date:   Mon, 19 Jun 2023 14:04:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [GIT PULL] io_uring fixes for 6.4-rc7
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <d2d1c92b-e682-9fbb-120b-23a8726c142d@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <d2d1c92b-e682-9fbb-120b-23a8726c142d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

> A fix for sendmsg with CMSG, and the followup fix discussed for avoiding
> touching task->worker_private after the worker has started exiting.
> 
> Please pull!
> 
> 
> The following changes since commit b6dad5178ceaf23f369c3711062ce1f2afc33644:
> 
>    Merge tag 'nios2_fix_v6.4' of git://git.kernel.org/pub/scm/linux/kernel/git/dinguyen/linux (2023-06-13 17:00:33 -0700)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.dk/linux.git tags/io_uring-6.4-2023-06-15
> 
> for you to fetch changes up to adeaa3f290ecf7f6a6a5c53219a4686cbdff5fbd:
> 
>    io_uring/io-wq: clear current->worker_private on exit (2023-06-14 12:54:55 -0600)
> 
> ----------------------------------------------------------------
> io_uring-6.4-2023-06-15
> 
> ----------------------------------------------------------------
> Jens Axboe (2):
>        io_uring/net: save msghdr->msg_control for retries

Can you please have a look at
https://lore.kernel.org/io-uring/b104c37a-a605-e3c8-67ab-45f27e158e21@samba.org/
Before this goes into stable releases...

Thanks!
metze
