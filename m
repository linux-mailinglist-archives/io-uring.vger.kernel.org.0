Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF3CA15FBF9
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 02:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgBOBU5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 20:20:57 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44719 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727639AbgBOBU5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Feb 2020 20:20:57 -0500
Received: by mail-pg1-f196.google.com with SMTP id g3so5661515pgs.11
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2020 17:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Kq5+zg+BjWYmBTuTOQDyEJGh1pC/f5gJH8KP9SmE9fg=;
        b=XpYT65RR0Fi4QsHUQLu3MF7Hoh1ULvt2aa9HhPIww9v/ulAN+5OD5QeZsoRNTQKRVu
         pptPtLqwblpNiw0bFy8+N3Ka+gpX1rEnvjFaSjFJfYh3BH+iECY9n3LFtt0FHLvmQu0R
         rdqP2WfinfVvWWsSVaZMDWwd+FVhOAeMQkwwTJvGtAd26aII1GBSWjcR28K3oN1mVi1w
         XYNccYp6c9hCBG+4nIcKpczRRlFWgGGcv3zWIL3t4abUSNedJTn24AALa/IPQNYmOgGv
         1pAqwpKqU4zZ0pyQBFoDY1NG44ExZTKzs51eseFiC7/S228ehhCOB7GmJerLdycMWqp7
         XThw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kq5+zg+BjWYmBTuTOQDyEJGh1pC/f5gJH8KP9SmE9fg=;
        b=TgBe6laLFCVKO+qYi+jBOQPTWfMO0DVXG0qh2H5j+MjVviDg6pQyk5pE1xZB41AWQj
         jBqaWK7z1r/twTn4yqbywU1ZruKt1kftoWw7pTIwfvI69vlfvPg94AmIxYaKq5FEJMTE
         829559HINYC+S1XV63MUnPF7jor8eYrnYPmbpAjzdPkU4sxGBXVy249hUT1CldUoAs79
         hV/LBhXyMDO/MxJoAayxH1sjU2A7wydoipePzt528asIggiWcSxDanAyfi7jPH0Eqn3K
         XPY4Khdw5XlkPOqo5G3L/OiR7vJqYZmTEf/+exLYGDDwA86Obu1SSA0CcNpshcOjqZzD
         0xhg==
X-Gm-Message-State: APjAAAWEtXTeM+EEXnrZ8NTk7fQ+xNCHJr765mT14+O/DiihM6h1cfKh
        R+ngrifgh/C8UJB2D+fj3qHlyA==
X-Google-Smtp-Source: APXvYqzL/dVBWz2L9E/f9zq7JCtYavJdmzKMwmTGXxYnq9BfNcmSMoYZ/kGg/y4DyOxFXOqZ60EMRg==
X-Received: by 2002:a63:d04c:: with SMTP id s12mr6373035pgi.105.1581729655556;
        Fri, 14 Feb 2020 17:20:55 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id p3sm8492017pfg.184.2020.02.14.17.20.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 17:20:55 -0800 (PST)
Subject: Re: [GIT PULL] io_uring fixes for 5.6-rc2
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <d72d51a9-488d-c75b-4daf-bb74960c7531@kernel.dk>
 <CAHk-=wixEw+wKJzwfEFnBYLNt5zU6zA2kpNVu_36e33_zsawKA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ba8f3ef7-a696-0e47-eadb-7772e6aba725@kernel.dk>
Date:   Fri, 14 Feb 2020 18:20:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAHk-=wixEw+wKJzwfEFnBYLNt5zU6zA2kpNVu_36e33_zsawKA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/14/20 3:07 PM, Linus Torvalds wrote:
> On Fri, Feb 14, 2020 at 8:45 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Here's a set of fixes for io_uring that should go into this release.
> 
> Whaa?
> 
>           for_each_node(node) {
> +                if (!node_online(node))
> +                        continue;
> 
> that's just silly.
> 
> We have 'for_each_online_node()' for this.
> 
> There's something like four patterns of that pointless thing.

Sorry, that definitely should have been for_each_online_node() for
those, guess I didn't think of that when making the change.

> And in io_wq_create(), do you really want to allocate that wqe for
> nodes that aren't online? Right now you _allocate_ the node data for
> them (using a non-node-specific allocation), but then you won't
> actually create the thread for them io_wq_manager().

I was thinking about this a bit, and as far as I know there's no good
way to get notified of nodes coming and going. And I'd really like
to avoid having to add that to the fast path.

So this seemed like the lesser of evils, we setup the wqe just in
case the node does come online, and then rely on the manager
creating the thread when we need it. Not sure what setup was run
to create it, I haven't come across any boxes where we have nodes
that are present but not online.

> Plus if the node online status changes, it looks like you'll mess up
> _anyway_, in that  io_wq_manager() will first create the workers on
> one set of nodes, but then perhaps set the state flags for a
> completely different set of nodes if some onlining/offlining has
> happened.

We'll look into making this more clear and bullet proof.

> I've pulled this, but Jens, you need to be more careful. This all
> looks like completely random state that nobody spent any time thinking
> about.
> 
> Seriously, this "io_uring FIXES ONLY" needs to be stricter than what
> you seem to be doing here. This "fix" is opening up a lot of new
> possibilities for inconsistencies in the data structures.

We'll get it sorted for 5.6. Thanks for pulling.

-- 
Jens Axboe

