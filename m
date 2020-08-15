Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08B92453E9
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 00:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbgHOWHP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 18:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728276AbgHOVuo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 17:50:44 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25FCC0F26FA
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 11:15:46 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 74so6086770pfx.13
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 11:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=cgr9lRuKidkQIN9VikhOAh92WJNaoQaxLNAuYBGK56A=;
        b=e6PWsULuK1ZSnLzAcLaCBxDm6omzMQsVIJecKyrN7HSU4hXEnzWV60RwOx7FNce0Hj
         Ke+ZSTpcDU3JIhDtJRiZvJgsp122dUidCpvjhkRKTwv4T2amwjdG2UIi79GZF9VbMCRc
         Ic8PK+2wuWD2Bm6eQZbWs8D3M+V9nhh2hzO1z95l3MlCIRKCGscsoer6Qj6nDTn2LmPA
         4Zb19YxRviqttOYunp4fH/bLzZvrkhQVnFyHcwGDJTPLf2C0W7BZQ0DYeqM9vBfrf65i
         5A8NFr8SWQ9gJwZpKTSRbtl/NV2ezk4rIYpB93OYN6gxUYxpSekq7y8hqke+WXPgT2WU
         YH1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cgr9lRuKidkQIN9VikhOAh92WJNaoQaxLNAuYBGK56A=;
        b=K7cInlD6tLY7dIYHBYocRtRO40uDYKqQFFFpM15IRqybLzvEhOMFXUzXtZwA+ZlcuY
         vzVplnTmvwi+F5gCeIIlN8Bl7rWeOwMkxDAap65M/IZRRxz17P5u7uKSiPmKVk3PquaE
         7ZNcZQjC+h3X1ZKIB6J/lRYX7gRpa5IYXTebF93nKRo4T2HkW/HU0Qw4rneX/ioml5sn
         q1jIwQHtlhWQ93upxkOsaqRKDUpnS7YU1lQaqKTMsrHuROi9KY3MkkPw1Mw1r+p3DtRd
         to4MGbZCQYRtvMZC7faoCet/F58p7+/IcCHSpky5eE/Vp5vACnj8C1kawL0o5QX6LgRt
         d+4Q==
X-Gm-Message-State: AOAM531bXpm6K+GbayhfUQ0KqJCsejTbM+vS2/RLb8RUpfroSn95VAlD
        WWlu0jybun2E9evQAF41WNsMQQ==
X-Google-Smtp-Source: ABdhPJzM1CZhjXBL0TtrdKhbrHniS7YBWuX7Am0ORQZPsO3178OMkcj+cFPwslOf9e4QBeTzu5pGhQ==
X-Received: by 2002:a62:8cd3:: with SMTP id m202mr5746565pfd.184.1597515346498;
        Sat, 15 Aug 2020 11:15:46 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:6299:2df1:e468:6351? ([2605:e000:100e:8c61:6299:2df1:e468:6351])
        by smtp.gmail.com with ESMTPSA id z77sm13633210pfc.199.2020.08.15.11.15.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2020 11:15:45 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: Re: possible deadlock in io_poll_double_wake
To:     syzbot <syzbot+0d56cfeec64f045baffc@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <000000000000923cee05acee6f61@google.com>
Message-ID: <f9436b5a-c8d5-1c45-3039-6e2ddea3a313@kernel.dk>
Date:   Sat, 15 Aug 2020 11:15:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000923cee05acee6f61@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz dup general protection fault in io_poll_double_wake

-- 
Jens Axboe

