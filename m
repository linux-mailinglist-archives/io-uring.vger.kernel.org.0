Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E784008D9
	for <lists+io-uring@lfdr.de>; Sat,  4 Sep 2021 03:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350748AbhIDAuQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 20:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350711AbhIDAuQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 20:50:16 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6342C061575
        for <io-uring@vger.kernel.org>; Fri,  3 Sep 2021 17:49:15 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id e16so790379pfc.6
        for <io-uring@vger.kernel.org>; Fri, 03 Sep 2021 17:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Uz3M4WmCspE/SP/HhtAcp2zgUd6rTexaM0a2iXogNnM=;
        b=Efddl6Z5Kjdb+t6KIEqKq1iAabmBKR59ZWQE8sjbwA90r0296NrPr1ML6xLYhjOOAp
         iNeTM2zi0D1md6WRX4Vj86zjZnXvoalsDjkck3MnR2TvpQRkmdpqfA38ZTi8gcEKTs3A
         f4en4XoF6OytXl8FimebaqzaLqqa364yMsm1Ym8oMK3tM/6ZQ7K9o3qn1DzyavXbG2Im
         gXgCLFVXOpAm3+Njqo2fcxEF2vUZr+Zy23kxIu3WjtBbjpOzzP0v/ttRy39ZiMIs9/Ga
         nBeVPeUk09kL47UWMMKSxBoXXqKNLXL5T81/hNlxJLWX/99jYarp9QTQFDQvrUixOXvV
         +i8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uz3M4WmCspE/SP/HhtAcp2zgUd6rTexaM0a2iXogNnM=;
        b=lE3QtFebV7LPkcyYQ3WdjApI7wFB4jMd1MnQiQ0BEFkjrHYF8mddagi3ARJjeOvWMq
         ChL9XgOaNr29PzEsp1EpZbGC2olBV2Nc8kFUgxDSZ2OPnPuiwephhcbtMc6Y8bbpM62J
         MUHTUy2ANRMp0QqHP29LTwpcPF0dnhsWZGdW0omDcLp/v99DlyM3k1MNcAZBBSCUkzBl
         qHZWYvzvUYSK5RrtrLH0f/cZxhWA35zoFDve3H16AEYncr0bH+ehlKfaxi5P0i9Y0/Az
         bhhwmitPcQE9ivgJVgKxwaA3AmuDl0RDAP/Jiy9l8q1E7ec4rIt52eHSpBfk7+mO0Hfj
         0hag==
X-Gm-Message-State: AOAM533N7DM0T2di9qxCSy8QSLoWUp7JETz2Z1QYkzpYZcJuldouu5IH
        2aOd06jLEC1g09n/uRoCwqo6mg==
X-Google-Smtp-Source: ABdhPJxrr3xwgoVIiY2SVw4cB0/Ika1nxhg0dzvPDBNZNEsgSNjb4QT6nB09SLNZMsHW7eKlEKZ4QA==
X-Received: by 2002:a05:6a00:aca:b029:392:9c79:3a39 with SMTP id c10-20020a056a000acab02903929c793a39mr1461401pfl.57.1630716554735;
        Fri, 03 Sep 2021 17:49:14 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id u24sm475478pfm.85.2021.09.03.17.49.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 17:49:14 -0700 (PDT)
Subject: Re: [syzbot] general protection fault in __io_arm_poll_handler
To:     syzbot <syzbot+ba74b85fa15fd7a96437@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Dmitry Vyukov <dvyukov@google.com>
References: <000000000000f0da6305cb1feacb@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <15a67989-9ad7-11ef-9472-8e16ca6ec11a@kernel.dk>
Date:   Fri, 3 Sep 2021 18:49:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000f0da6305cb1feacb@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/3/21 5:47 PM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> 
> Reported-and-tested-by: syzbot+ba74b85fa15fd7a96437@syzkaller.appspotmail.com
> 
> Tested on:
> 
> commit:         31efe48e io_uring: fix possible poll event lost in mul..
> git tree:       git://git.kernel.dk/linux-block for-5.15/io_uring
> kernel config:  https://syzkaller.appspot.com/x/.config?x=914bb805fa8e8da9
> dashboard link: https://syzkaller.appspot.com/bug?extid=ba74b85fa15fd7a96437
> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
> 
> Note: testing is done by a robot and is best-effort only.

Dmitry, I wonder if there's a way to have syzbot know about what it's
testing and be able to run the pending patches for that tree? I think
we're up to 4 reports now that are all just fallout from the same bug,
and where a patch has been queued up for a few days. Since they all look
different, I can't fault syzbot for thinking they are different, even if
they have the same root cause.

Any way we can make this situation better? I can't keep replying that we
should test the current branch, and it'd be a shame to have a ton of
dupes.

-- 
Jens Axboe

