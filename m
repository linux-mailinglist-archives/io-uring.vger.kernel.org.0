Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FD665324A
	for <lists+io-uring@lfdr.de>; Wed, 21 Dec 2022 15:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiLUOPH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Dec 2022 09:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiLUOPC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Dec 2022 09:15:02 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFA563E5
        for <io-uring@vger.kernel.org>; Wed, 21 Dec 2022 06:15:02 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id l4so4339210pld.13
        for <io-uring@vger.kernel.org>; Wed, 21 Dec 2022 06:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e3s3eUN13P0YyiIh04vUnhbvM9ex+x79k75uc9kYjoY=;
        b=NlmK0wEvd7vplOpzUmPU03RyaQbkbPfuyl/Pk+WIb0DSoBKctvWloQjTXbhZyuRwIU
         zysLGnkVoDnh2HwXH4YjgfMZqfMSO+Rxk7hoCeuYrosAXwrvAj9oDXnnhhy0G0nfo7zr
         2L1mccRjeORel4DO9+61DjDAsTayE9HG2mwtwboqB/vqFC5LOYDkMUA9W/SdyymWFtDU
         ZYQKNNcTbXEChSxLC0GIYSlcUkyfL1Nzy3XZqClpal1j46NcNMzffJ+/P/vlvV6xinC2
         3ByGkqQahHqHE7C6X1DRRkYSobcfiU+TW5zZugFmGPKqIfkPouJghE2qmVifZdU52cqU
         3Wyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e3s3eUN13P0YyiIh04vUnhbvM9ex+x79k75uc9kYjoY=;
        b=LCvpQYJJl5gV5mnPkAHkQCTbTNkQLzYUJ8v1oQ4HDhyp99RgM+IPJU1XOucjeHhsaZ
         T7VUN0IE/YHipJ8l8aQq0xw/JIQt+SUBLKu5O7ftPX1u1dnyMwIzPfPtqtdyfT+jh2C7
         RSV1jBfBsocFm1uNmTFbTrzW2ROrNtCopJwWbkV2ClHCeIeNRic2uEGI5mQxyd8D+vei
         U70QbRB4XgrxB4ZyGf8CuhIjSfE6vETZlhMm5bNTcpuQ5NSpwC0Z4KGf0ZOeP6f1jTrn
         mwbiIDWY8VDhyPrC4sZDiY2BBTigfzqg9ifumFXdifHn9T2aj/O09+EL0awbSCUhbxG6
         p6EQ==
X-Gm-Message-State: AFqh2krOt7yIYFUItuOeDkhLE3XnnUjOMEBwbOiWaY6TxjIJOQBonaXc
        913QcuUfKYHejBR2wvvyAR8evQ==
X-Google-Smtp-Source: AMrXdXsl3DyKqvOK0zD3bPv4Qr/IOnCcdFMEPRDTDTH3t6mZ/5OflogHxzfWR4cW1qnXetvOuvlyng==
X-Received: by 2002:a17:903:3311:b0:189:d0fa:230f with SMTP id jk17-20020a170903331100b00189d0fa230fmr511000plb.4.1671632101577;
        Wed, 21 Dec 2022 06:15:01 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a14-20020a1709027e4e00b00186acb14c4asm11551396pln.67.2022.12.21.06.15.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Dec 2022 06:15:00 -0800 (PST)
Message-ID: <bd9ab0b5-4c87-174d-78cd-c04aa12738b2@kernel.dk>
Date:   Wed, 21 Dec 2022 07:15:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [syzbot] WARNING in io_sync_cancel
Content-Language: en-US
To:     syzbot <syzbot+7df055631cd1be4586fd@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000003a14a905f05050b0@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0000000000003a14a905f05050b0@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/20/22 11:03 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    77856d911a8c Merge tag 'arm64-fixes' of git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=102b57e0480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=334a10f27a9ee2e0
> dashboard link: https://syzkaller.appspot.com/bug?extid=7df055631cd1be4586fd
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14ac9ee7880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=142b36b7880000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/84863f051feb/disk-77856d91.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/87614e2a8a26/vmlinux-77856d91.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/cb76bad63a90/bzImage-77856d91.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+7df055631cd1be4586fd@syzkaller.appspotmail.com


#syz test: git://git.kernel.dk/linux.git io_uring-6.2

-- 
Jens Axboe


