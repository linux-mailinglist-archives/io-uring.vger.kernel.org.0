Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C10B65455A
	for <lists+io-uring@lfdr.de>; Thu, 22 Dec 2022 17:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiLVQpc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Dec 2022 11:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiLVQpb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Dec 2022 11:45:31 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802933055A
        for <io-uring@vger.kernel.org>; Thu, 22 Dec 2022 08:45:29 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id t11-20020a17090a024b00b0021932afece4so6258341pje.5
        for <io-uring@vger.kernel.org>; Thu, 22 Dec 2022 08:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e7cHe2ofFq/qzzylun7YjrmSfr+kqiVwa6EeaitIMwg=;
        b=X9e9p/9m0ihqtklCkS/PS6AxvSwz/1df6OJoNs6jRJ0gIeQxzvqAhM4Sgf/S9FE2fN
         fthRuRty3d66AL7zR9owxJRiaQppPMjsXuurYcNrLQ0/CP6RVKWtGIgBZ7GAFUYnV6mH
         Po5CBb79NfFlFURbepIu5f4eGsdHexCyAFboLxSuK91YQr8xzBaX7DQ6envt06ApK16W
         a1ySrrZhAT1BucPfMDtF/mQJHdAsI3Fj57/F1uIwuF+Ki1PPxwU5em/36P3aOPj8E6ZU
         J5Y/LA8n0Qr4qrno/uPtJQi+FV4q1lv6wyAlKLd7J8mumhPs/ORb2k/bPqBstH41w3Yv
         HVoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e7cHe2ofFq/qzzylun7YjrmSfr+kqiVwa6EeaitIMwg=;
        b=lFRb4wV11CkDdEQ3GsiKnP3NQUHy4rcNNCONDGV88em31lD/vTIR6+fjBDXpnStw+N
         mLCPL8ZXeWK79o6SfZP74wkOgyFF9wBJXbf+q486XE8wz6yRSicGNV2F3+DG4KEdrPLm
         I6k/nJOZIjTnhuullCP2eekpoQ1VRKWYBwwzMtsdZtty72bD9y5JgELa2gFRzbJrenVu
         YQ46MMdMmitA5TU8TN2rwotFQm9duB2xpOuFX8o+uWNe/5gmwwspDQ1/dTcgBXcmv6t/
         /WQGDJoZsHwrQ+Jaknj8qaPiedKR1ikOXeCYR9FSCwMyEAUcNjtdYtIWRkLCmgYZrCq8
         RYiQ==
X-Gm-Message-State: AFqh2kopfXQIB8Rad6aaYSPIuOEsvfdCM0nxuzn2ty76EK6QvCDSr1YG
        rfrfdzg/2xbtr/5guxD8CmAlEPOeq/EQFn0D
X-Google-Smtp-Source: AMrXdXsg9Z9Ogo2bMjXySgcXDOKpZdH97qzmAJbrqPL4l7F2/yRq5iyePSm72E1AsQldhnW7tmKnxA==
X-Received: by 2002:a17:902:74ca:b0:189:9031:6750 with SMTP id f10-20020a17090274ca00b0018990316750mr1659601plt.5.1671727528883;
        Thu, 22 Dec 2022 08:45:28 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s12-20020a170903200c00b00188fadb71ecsm812611pla.16.2022.12.22.08.45.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Dec 2022 08:45:28 -0800 (PST)
Message-ID: <a6f9ca2f-1a8a-828f-8cc1-fd9292e88770@kernel.dk>
Date:   Thu, 22 Dec 2022 09:45:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [syzbot] WARNING in io_sync_cancel
Content-Language: en-US
To:     syzbot <syzbot+7df055631cd1be4586fd@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000d3af6205f0644515@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000d3af6205f0644515@google.com>
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

On 12/21/22 10:52 PM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> INFO: rcu detected stall in corrupted
> 
> rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { P5772 } 2680 jiffies s: 2845 root: 0x0/T
> rcu: blocking rcu_node structures (internal RCU debug):

Wish there was more of a trace here, but I don't think this is
related to the original issue.

-- 
Jens Axboe


