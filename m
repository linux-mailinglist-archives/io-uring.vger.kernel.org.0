Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023E96537B3
	for <lists+io-uring@lfdr.de>; Wed, 21 Dec 2022 21:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiLUUmm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Dec 2022 15:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234961AbiLUUmX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Dec 2022 15:42:23 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED7C275F0
        for <io-uring@vger.kernel.org>; Wed, 21 Dec 2022 12:41:53 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id h6so8637770iof.9
        for <io-uring@vger.kernel.org>; Wed, 21 Dec 2022 12:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t1yzOmm6ToE262pU3uBC9wuXg/0Sq6TX0VpAt7Es0bU=;
        b=0jcc35ECS+P1uvshnoXgTB2m2l8b/h/XZHSJGK85sDEewrPkBpf1Y0TjU2oyebn/yl
         iXwD2bARYVRyOJCiGgmHt/7Z5rwR1fz8vWX/5IWF+1ku9dc04AFvubY7nONXiTRNqri9
         BbKaq04YAkCNPWQCx/AgpMFzBqKE3B+m4pnCV8eNSF3osd8tJSg90qFSzYQJ81QrW+DK
         eOzqvO8F4OWN3dn68RnXmzxZjoWanmfd2sNdW9pfzWFQ0hI1UW98pTDcOH1+KXZ73EKp
         qwaEKZq1EgHQ4/ea99LZixliyEbtJre0zHxYq1MwAH7soxxFkGyMbswpfwvMnKs4/stp
         OicA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t1yzOmm6ToE262pU3uBC9wuXg/0Sq6TX0VpAt7Es0bU=;
        b=QN2hLG7VHcSSptzsDRuZVOIwCTJG7HJWQ8cUFSFYJ6VtBVOk0QZhONwqw6NSOIPZ2p
         b+ui01Uv1LUbsizNTKi+HnPOOSKzb1b1UAL54vndUn3mjAcpHzzg4t0ynXplat3UwNPY
         zsRXyX9FImPPuM+E2/+4m3C+l5PVXsgxmBzS4L8vTkYtbMbe/TxSh06cBnITomD1P9i/
         OHRDEHPaZ1qr1H9zxJOIq/P3SeqvnoFmzPDr/37867dctWjPtGPNpa/yhouK5x/dX7vc
         68g9BBBBIjQJS+MaeRRpDvJG5nZ6MnwEdaPHLKKgqDpoEk1hDEMye/tSHBuZ87mvus9H
         lXEA==
X-Gm-Message-State: AFqh2krlEZeGxEiVw1KlNs0SznaHYgrviQwlUifidlf60uRrZgDEyUxS
        xAd7bbtrOQJiGRFdOnrHlATp/w==
X-Google-Smtp-Source: AMrXdXvcPC8kEPqWiiDETHKp877+RHhAAN+wl8ShPN+7U/DGr4wVxkZehPd0dNvTOiZ2igHpgVPzJA==
X-Received: by 2002:a05:6602:218a:b0:6df:b991:c03e with SMTP id b10-20020a056602218a00b006dfb991c03emr412052iob.1.1671655312649;
        Wed, 21 Dec 2022 12:41:52 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b12-20020a05660214cc00b006eba8966048sm3741196iow.54.2022.12.21.12.41.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Dec 2022 12:41:52 -0800 (PST)
Message-ID: <0021f079-0d7e-0c51-64ad-9d9d17652e88@kernel.dk>
Date:   Wed, 21 Dec 2022 13:41:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [syzbot] WARNING in io_sync_cancel
Content-Language: en-US
To:     syzbot <syzbot+7df055631cd1be4586fd@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000084d53b05f058cabc@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <00000000000084d53b05f058cabc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/21/22 9:10 AM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> INFO: rcu detected stall in corrupted
> 
> rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { P5778 } 2634 jiffies s: 2893 root: 0x0/T
> rcu: blocking rcu_node structures (internal RCU debug):

#syz test: git://git.kernel.dk/linux.git io_uring-6.2

-- 
Jens Axboe


