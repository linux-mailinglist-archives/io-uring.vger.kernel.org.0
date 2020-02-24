Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E52A16AA5B
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 16:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgBXPo6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 10:44:58 -0500
Received: from mail-wm1-f54.google.com ([209.85.128.54]:37086 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727734AbgBXPo5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 10:44:57 -0500
Received: by mail-wm1-f54.google.com with SMTP id a6so9931895wme.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 07:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=Ny33y7u5/3B+EhkMccz+r1D/XcEttWNt2/FaZIEJbV0=;
        b=Wr7Y74cS29gMLLpvIv9H14V2zszc2gHjh27lq5BxGqll65LrWhLXtedKrQK1fBOlQr
         HxgKJjuW2RkRDssg2cjifcTEcDZTaBiwiOG9LMeGgoW2HYAyegJiwhXQa/Raj8a3fGuq
         BhOUs2Tm3OeL4WOJv0704ktrtMqnjnCK6u7Mo7ngWrY2Id0m5xGBSbGXTMIWs7ni412T
         Dp7f4n7jD+o7PUPnIIXCtg8buRq3k9Hi4d3j54zzXFvtAaXpbAwZnlZsIEI/w9xOCCC3
         U5MSYMW52xafVyBEnoGcG0mHcBpwzTdQGwnDdm83XpaN/cBuh7lq/4xPeDIcB9DikJNu
         YVRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=Ny33y7u5/3B+EhkMccz+r1D/XcEttWNt2/FaZIEJbV0=;
        b=tS2T4JMq3Ag6PAXe9RO763JukI+kCWa4osfi1VZPuS/STUhvXSB1HVQEdNb8wweCOy
         5CBiIrTaN/oLlyO7Htd3KryPE6JmxJ6qO94Jxg5gEa743h9jEEfgrJq0e42V3DJIUX+Z
         yo/9U0qUvjxBMECS9oXq7JIfiXh5O05Wze0dCd1wsGLmiDEuMpjJwwR3IAmoVt4GHvbH
         cBWHlDd1xeWHtxnrckMwLud26jQNljaKYfGWRzUqRap6XnuiSM4KOv3o9gt76toLhds+
         x0oE7YucV7ngI+KRQcr/EhvOMgUyOZbC4ZgjZPHbQO4KyAIuBkUc4dCoMLXWvQwSWy5r
         78YQ==
X-Gm-Message-State: APjAAAWSBtMi9+R7VmXWsA7isqi/fc1PlkIT0AOM9sdb4c13XVJHAU3C
        IRYbVxGogssiaKufhdo2y9xjqQB5
X-Google-Smtp-Source: APXvYqxs7A5AH+9C09222yolq0kLv/ZMSBylBkxJSLZxfGSdXkoTY58aYIUiUwqj/BXeQICgy1ye9g==
X-Received: by 2002:a1c:a1c3:: with SMTP id k186mr22711037wme.179.1582559094457;
        Mon, 24 Feb 2020 07:44:54 -0800 (PST)
Received: from [192.168.43.177] ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id c9sm18899576wmc.47.2020.02.24.07.44.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 07:44:53 -0800 (PST)
Subject: Re: Deduplicate io_*_prep calls?
To:     Jens Axboe <axboe@kernel.dk>, Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
 <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
 <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
 <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
 <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
 <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <23a49bca-26a6-ddbd-480b-d7f3caa16c29@gmail.com>
Date:   Mon, 24 Feb 2020 18:44:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vmzQiEjEfpBo6Y0RnUeaecQ9aT5wOt99q"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vmzQiEjEfpBo6Y0RnUeaecQ9aT5wOt99q
Content-Type: multipart/mixed; boundary="8Wa6b9pTvu2EZfX3LVgbywOW7V57G0NY9";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Andres Freund <andres@anarazel.de>
Cc: io-uring@vger.kernel.org
Message-ID: <23a49bca-26a6-ddbd-480b-d7f3caa16c29@gmail.com>
Subject: Re: Deduplicate io_*_prep calls?
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
 <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
 <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
 <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
 <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
 <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
In-Reply-To: <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>

--8Wa6b9pTvu2EZfX3LVgbywOW7V57G0NY9
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 24/02/2020 18:40, Jens Axboe wrote:
> On 2/24/20 12:12 AM, Andres Freund wrote:
>> Hi,
>>
>> On 2020-02-23 20:52:26 -0700, Jens Axboe wrote:
>>> The fast case is not being deferred, that's by far the common (and ho=
t)
>>> case, which means io_issue() is called with sqe !=3D NULL. My worry i=
s
>>> that by moving it into a prep helper, the compiler isn't smart enough=
 to
>>> not make that basically two switches.
>>
>> I'm not sure that benefit of a single switch isn't offset by the lower=

>> code density due to the additional per-opcode branches.  Not inlining
>> the prepare function results in:
>>
>> $ size fs/io_uring.o fs/io_uring.before.o
>>    text	   data	    bss	    dec	    hex	filename
>>   75383	   8237	      8	  83628	  146ac	fs/io_uring.o
>>   76959	   8237	      8	  85204	  14cd4	fs/io_uring.before.o
>>
>> symbol size
>> -io_close_prep 0000000000000066
>> -io_connect_prep 0000000000000051
>> -io_epoll_ctl_prep 0000000000000051
>> -io_issue_sqe 0000000000001101
>> +io_issue_sqe 0000000000000de9
>> -io_openat2_prep 00000000000000ed
>> -io_openat_prep 0000000000000089
>> -io_poll_add_prep 0000000000000056
>> -io_prep_fsync 0000000000000053
>> -io_prep_sfr 000000000000004e
>> -io_read_prep 00000000000000ca
>> -io_recvmsg_prep 0000000000000079
>> -io_req_defer_prep 000000000000058e
>> +io_req_defer_prep 0000000000000160
>> +io_req_prep 0000000000000d26
>> -io_sendmsg_prep 000000000000006b
>> -io_statx_prep 00000000000000ed
>> -io_write_prep 00000000000000cd
>>
>>
>>
>>> Feel free to prove me wrong, I'd love to reduce it ;-)
>>
>> With a bit of handholding the compiler can deduplicate the switches. I=
t
>> can't recognize on its own that req->opcode can't change between the
>> switch for prep and issue. Can be solved by moving the opcode into a
>> temporary variable. Also needs an inline for io_req_prep (not surpring=
,
>> it's a bit large).
>>
>> That results in a bit bigger code. That's partially because of more
>> inlining:
>>    text	   data	    bss	    dec	    hex	filename
>>   78291	   8237	      8	  86536	  15208	fs/io_uring.o
>>   76959	   8237	      8	  85204	  14cd4	fs/io_uring.before.o
>>
>> symbol size
>> +get_order 0000000000000015
>> -io_close_prep 0000000000000066
>> -io_connect_prep 0000000000000051
>> -io_epoll_ctl_prep 0000000000000051
>> -io_issue_sqe 0000000000001101
>> +io_issue_sqe 00000000000018fa
>> -io_openat2_prep 00000000000000ed
>> -io_openat_prep 0000000000000089
>> -io_poll_add_prep 0000000000000056
>> -io_prep_fsync 0000000000000053
>> -io_prep_sfr 000000000000004e
>> -io_read_prep 00000000000000ca
>> -io_recvmsg_prep 0000000000000079
>> -io_req_defer_prep 000000000000058e
>> +io_req_defer_prep 0000000000000f12
>> -io_sendmsg_prep 000000000000006b
>> -io_statx_prep 00000000000000ed
>> -io_write_prep 00000000000000cd
>>
>>
>> There's still some unnecessary branching on force_nonblocking. The
>> second patch just separates the cases needing force_nonblocking
>> out. Probably not quite the right structure.
>>
>>
>> Oddly enough gcc decides that io_queue_async_work() wouldn't be inline=
d
>> anymore after that. I'm quite doubtful it's a good candidate anyway?
>> Seems mighty complex, and not likely to win much. That's a noticable
>> win:
>>    text	   data	    bss	    dec	    hex	filename
>>   72857	   8141	      8	  81006	  13c6e	fs/io_uring.o
>>   76959	   8237	      8	  85204	  14cd4	fs/io_uring.before.o
>> --- /tmp/before.txt	2020-02-23 21:00:16.316753022 -0800
>> +++ /tmp/after.txt	2020-02-23 23:10:44.979496728 -0800
>> -io_commit_cqring 00000000000003ef
>> +io_commit_cqring 000000000000012c
>> +io_free_req 000000000000005e
>> -io_free_req 00000000000002ed
>> -io_issue_sqe 0000000000001101
>> +io_issue_sqe 0000000000000e86
>> -io_poll_remove_one 0000000000000308
>> +io_poll_remove_one 0000000000000074
>> -io_poll_wake 0000000000000498
>> +io_poll_wake 000000000000021c
>> +io_queue_async_work 00000000000002a0
>> -io_queue_sqe 00000000000008cc
>> +io_queue_sqe 0000000000000391
>=20
> That's OK, it's slow path, I'd prefer it not to be inlined.
>=20
>> Not quite sure what the policy is with attaching POC patches? Also sen=
d
>> as separate emails?
>=20
> Fine like this, though easier if you inline the patches so it's easier
> to comment on them.
>=20
> Agree that the first patch looks fine, though I don't quite see why
> you want to pass in opcode as a separate argument as it's always
> req->opcode. Seeing it separate makes me a bit nervous, thinking that
> someone is reading it again from the sqe, or maybe not passing in
> the right opcode for the given request. So that seems fragile and it
> should go away.

I suppose it's to hint a compiler, that opcode haven't been changed insid=
e the
first switch. And any compiler I used breaks analysis there pretty easy.
Optimising C is such a pain...

--=20
Pavel Begunkov


--8Wa6b9pTvu2EZfX3LVgbywOW7V57G0NY9--

--vmzQiEjEfpBo6Y0RnUeaecQ9aT5wOt99q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5T70gACgkQWt5b1Glr
+6WczA/+O/1Phkx7/GQ5XThJhxDMSGRZ4XbbR4P/sfOYBxt7PO6PuUAPCwx57GAC
6NyH7qbWO9iesMLDohfTBdeF0MVM5wcy5k7mhbAuK6Cj+awU/Mu1I0O0wR8vH7A0
PcWc7gjE9Pgz8tqjXEsN6sNP38KWh0tPwtIu/I+CIxxHouYHLJPHCPoXwcO8nNFb
Q1pltWQI4H1ZsmHath037UdzJ+C8SL+6TsRv6ojeLIPE5Ni/KwHG5DT0SJ4PyJMB
Y8XmjBkbihL1puy/Mo74wcIZfb0HvdfyuUQe2F2v3sKjilqA4Wn/1hlKDFncG1gd
mzyZ7ZUkWADD4JSwTpEPjsZ9z32+xMdj7BAn+3/brR8eD4qcQazjmoDXimGnWdZU
tfKRmlQOKqF2k76oDYxbOvkjRGjiyC3/f9Y5CR53mCBCQBt3f1WnxyKNKq6JFzrH
Eh7S6OGSkhr/oFq/a+/HSszCE5t/bjwjvdqt4IALf8qA9nlVCSx23pn6eA0dXmSv
in3s5vfYsoZ4s8zHQ02xmiRuy25kPqvWi+9aEvnWlZcY1l7CKDBZnwkOJNVn5OJf
0t86/slImFxYxDG17s/KqLN8q31egWt8yBPWSVVKoubXkwFjJFrT+tF3TK/kvr9W
adRWHSCrGjwvDmuHzGMBndRpgyWHtkD46agKUHkKnNIUZ/HBqC4=
=nTbs
-----END PGP SIGNATURE-----

--vmzQiEjEfpBo6Y0RnUeaecQ9aT5wOt99q--
