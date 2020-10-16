Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912822907EF
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 17:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395486AbgJPPFM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 11:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395449AbgJPPFL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 11:05:11 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B753C0613D4
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 08:05:10 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id e7so1645844pfn.12
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 08:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JzDapqDbRJOBrcwfT3VXmT64IkW9T231UgaoFDr0sF8=;
        b=0glTDtO0g6ULH4unmoVi89hsOBGAjkH7mvxE17QE3sXs8i1++TiqqRj3348WLuXenf
         5JhThL++0ewfRD12fB7paE0fUuwT19N/bD9zIPtvWd2/BnhL0CxCTLtdLBFJfU6Ce6fI
         o9kx6GYlrRhQQeOdrbKGMRLiYIvQTXolfvw8OTg1UNJAhgMwszYjwFitUXaCCqofGLJV
         tT3mwckirKMt0YSDLDKk8If069od9ilyxbw1MVbuIVNKhflomy2/b/AD4stg8Y6SFrs+
         c4y2tWEM/mCTO+YhNqUBBEG5FnfQ5E82mMlY9zwWLtePCCpB4eRAemrrFpndA/p5Rgor
         LOwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JzDapqDbRJOBrcwfT3VXmT64IkW9T231UgaoFDr0sF8=;
        b=b0X3X4z7uKDLYZTJNOv2m06YvTGMcNVU6pb8eKFSwyLTIJ6C1yiZef7I+TsVOecso1
         LEi0QEe2mpfSJytvWLNJg8RNXRYKXTi4zkbhRmxo/iYhxNh7qQO+vQUQGsHXXchqUbys
         bnqYTUkC8SvsUTEFA3tJpJAbNyj6um6gp/E2AIxmfSbnp/PWga6EpvcPs5pZyhMv+jtw
         WLphi/kI9L4Li8woQ/zy4Zp4sIav45eNowrWpM0wiwysUf8630H/xiOrK6B6Nh2u4Xpv
         vB9GmxGheXpxBOBIs+eTcgzzGCrfXQrUOCsMf+jaVTAlhW5KQVHB20yyDjhO0clJ3i5/
         Fm2Q==
X-Gm-Message-State: AOAM530113cB3HCvaR+ZRTZ15XtbvsnkzGwT3Az4FYZ58wseWgrYCbzM
        1ho1f0QHOANMp4Qtfog3jZcBpw==
X-Google-Smtp-Source: ABdhPJwcReiXk9I+LxqFHFhEsPAC1xeFP+wgqzl8qwBJl3DED7LyCalm+HyYY7zEMMP8RzjDKPrdxg==
X-Received: by 2002:a62:53c5:0:b029:156:223c:e88b with SMTP id h188-20020a6253c50000b0290156223ce88bmr4039998pfb.38.1602860707643;
        Fri, 16 Oct 2020 08:05:07 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j37sm3091535pgi.20.2020.10.16.08.05.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 08:05:07 -0700 (PDT)
Subject: Re: WARNING: suspicious RCU usage in io_init_identity
To:     Qian Cai <cai@lca.pw>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk,
        syzbot <syzbot+4596e1fcf98efa7d1745@syzkaller.appspotmail.com>
References: <00000000000010295205b1c553d5@google.com>
 <a7cac632aa89ed30c5c6deb9c67f428810aed9cb.camel@lca.pw>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1039be9b-ddb9-4f76-fda3-55d10f0bd286@kernel.dk>
Date:   Fri, 16 Oct 2020 09:05:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a7cac632aa89ed30c5c6deb9c67f428810aed9cb.camel@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/16/20 9:02 AM, Qian Cai wrote:
> On Fri, 2020-10-16 at 01:12 -0700, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    b2926c10 Add linux-next specific files for 20201016
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=12fc877f900000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=6160209582f55fb1
>> dashboard link: https://syzkaller.appspot.com/bug?extid=4596e1fcf98efa7d1745
>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+4596e1fcf98efa7d1745@syzkaller.appspotmail.com
>>
>> =============================
>> WARNING: suspicious RCU usage
>> 5.9.0-next-20201016-syzkaller #0 Not tainted
>> -----------------------------
>> include/linux/cgroup.h:494 suspicious rcu_dereference_check() usage!
> 
> Introduced by the linux-next commits:
> 
> 07950f53f85b ("io_uring: COW io_identity on mismatch")
> 
> Can't find the patchset was posted anywhere. Anyway, this should fix it? 

It's just in testing... I already folded in this change.

-- 
Jens Axboe

