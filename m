Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A232621A1
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 23:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729912AbgIHVBK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 17:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728390AbgIHVBJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 17:01:09 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92AFC061573;
        Tue,  8 Sep 2020 14:01:08 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id gr14so429862ejb.1;
        Tue, 08 Sep 2020 14:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yuZq5gRtjnAOy/yKCa2afgQGQUjqZmPhiIecQIYO4eA=;
        b=qZsEpHsLLfxCed5410SrA8rAmZ525i2i7c4wbc8OXp8N6SlmVDp7h0875MI+d+P1AS
         yxU3wkXW4yiC+OW0P3j5dz9gOgAbwa1iNrlGZoAtC7msxKu+2dvktj66eIX2ytjX1E/9
         tlhUG1EWTLUt2uNd2eqM3WIyc/KT3lRvmJawNkK1qRtTlpUbJx333MGi2U++GtNkJzUy
         sGoKssErH5fzsyim9s8uSE9ZKabk2XzzJd8SS7nR+YI01aoe2wNNm2CZdHxQ0uf/2J8q
         p2iYtl/pXLibEbGb1vYO+scourbh+gHjRlX1qwaizNbyoVtz1VHcqi9rEv24HjIgIIwE
         yciw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yuZq5gRtjnAOy/yKCa2afgQGQUjqZmPhiIecQIYO4eA=;
        b=Cb6vozJOaeXOdLgj6vwxPZeXjPElhw0QIsjCWog3519ITh13njLSUkgdB/qI0z7rL1
         A/Jbu1H4Ev+5nOR2R4fzjkQYuhN28ZlXdFJuHXX9mj0yc/6Kus2CK917QKf26ydC2ZKG
         8zWX9a1/EgiChRAsY7Ob9caX03FNcfwVeH8HVuBLPKXEhDHGgMTU/UFYoiS+yp88+nsy
         /WuW0hLwvcRsGRxx6SHopYIaExkbsZMbhCjGxlxshObkfh+ulLxbw2L13q8Ko+e0a4S/
         3IsLABTo9VI1k7234VlewlRSp+gd2rOvR+KLy/AA6hnKis/MoOKE7Fua2CeBVRHBaCl8
         zDeg==
X-Gm-Message-State: AOAM530LwXPg6u43RY6wi0YjZZPoKWrwk+tIT5/f1wEKg3DQydm6fT4N
        5+r71flYmFbov45gyt9vf7s=
X-Google-Smtp-Source: ABdhPJxd/YVT4oASVxc+tdLEjp4ZtwajtJ+9bkMQrQ6WgK3fNzWkGQeJPkcAanshpa+NFiZECBmYgg==
X-Received: by 2002:a17:906:fcc7:: with SMTP id qx7mr377519ejb.254.1599598864615;
        Tue, 08 Sep 2020 14:01:04 -0700 (PDT)
Received: from [192.168.43.239] ([5.100.193.184])
        by smtp.gmail.com with ESMTPSA id bx24sm257157ejb.51.2020.09.08.14.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 14:01:03 -0700 (PDT)
Subject: Re: [PATCH next] io_uring: fix task hung in io_uring_setup
To:     Hillf Danton <hdanton@sina.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk,
        syzbot+107dd59d1efcaf3ffca4@syzkaller.appspotmail.com,
        Stefano Garzarella <sgarzare@redhat.com>,
        Kees Cook <keescook@chromium.org>
References: <20200903132119.14564-1-hdanton@sina.com>
 <9bef23b1-6791-6601-4368-93de53212b22@kernel.dk>
 <8031fbe7-9e69-4a79-3b42-55b2a1a690e3@gmail.com>
 <20200908000339.2260-1-hdanton@sina.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <778a8166-e031-e691-a44b-1199c68d6a29@gmail.com>
Date:   Tue, 8 Sep 2020 23:58:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200908000339.2260-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/09/2020 03:03, Hillf Danton wrote:
> 
> On Mon, 7 Sep 2020 06:55:04 Jens Axboe wrote:
>> On 9/7/20 2:50 AM, Pavel Begunkov wrote:
>>>
>>> BTW, I don't see the patch itself, and it's neither in io_uring, block
>>> nor fs mailing lists. Hillf, could you please CC proper lists next time?
> 
> Yes, I can. So will I send io_uring patches with Pavel Cced.

Thanks

>>
>> He did, but I'm guessing that vger didn't like the email for whatever
>> reason. Hillf, did you get an error back from vger when sending the pat	
> 
> My inbox, a simple free mail, is perhaps blocked as spam at the vger end.

-- 
Pavel Begunkov
