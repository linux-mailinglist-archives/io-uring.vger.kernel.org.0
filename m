Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 491771413E8
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 23:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbgAQWGQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jan 2020 17:06:16 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44470 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729246AbgAQWGQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jan 2020 17:06:16 -0500
Received: by mail-lj1-f196.google.com with SMTP id q8so4182177ljj.11
        for <io-uring@vger.kernel.org>; Fri, 17 Jan 2020 14:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:autocrypt:subject:message-id:date:user-agent:mime-version;
        bh=3GuvZtjVzLFRKrCJkVkvHiYBfL0M9AIbAzadquTysAc=;
        b=LfsFnnwNEnosUm6M191fFm6ELabu7kpu/sTCl04aO8UJrsdnylDA4SeCSRRq0elQYl
         A4d1skrW0Aw/9NL/Of0KO9P2s80SvFbzTzvQvM5f8g8pZWJ0AIMMgJ5gfoIMiIuCOUuV
         ESSUVkkDcO9SEm3SHRxIyl6BhgnFknQ2R41RHfTEWYiO9kNn/aJeaUr8AHFHLRuDy/mY
         o91HiQKSw+belK9cMmuUtWjr2coxqUL4yf56Yz+QaS/w5rfjP6dmzxvtg8BQS84sOJkY
         kxM7rAgEIGkYyFnqdHsQNygaQjzpFLFq+1C9Kp7PlasvAUSZeu+X9v75zKPx+VnYOBYO
         eUow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:autocrypt:subject:message-id:date
         :user-agent:mime-version;
        bh=3GuvZtjVzLFRKrCJkVkvHiYBfL0M9AIbAzadquTysAc=;
        b=BO3Q2yYPIAiWBDHqdNG1FamDVLwEPCn6okCSWTpT5mhyLCduKUm80Z53dwXPl1NxNm
         3N+JL94FOdU26LG8suqavRQoIfxm0m9Ulxlpr4WhnlUtHLnBlvpckOBzq2akpP/l0svz
         AZYdyPCNK7V3P7XVp9IlppypAc/cvlMStlA3ibuqqd8AZD1AZ28JfiKoawaCtP20WBE6
         t8kquM2GTm7HyxgbK30Qo2gMF//8xJ9FWNTSwFvqhUp5cww6Vunwjd3EI+WtqbxkWa9P
         JMgwBPmCigYUpheERH87F9ENdJeY0vB1MJLZZ200A9Ge6MyhhuWCwmdnn/ZXNL2RRDkt
         LqZQ==
X-Gm-Message-State: APjAAAUPRPCfT2M7CmpF6uVxsCwus5mYwCvncYFNRrG0YeSPYE/lq9Ui
        vUarkg6tHwZBbeakPRZivkXGVQ30
X-Google-Smtp-Source: APXvYqz2MpXANoO/fay8KxWxXpk/mlMRkAFAaMQxweONCwBc24WPyypDrCxc5TCgnZW34pv5w0KI8A==
X-Received: by 2002:a2e:a37c:: with SMTP id i28mr6484395ljn.118.1579298773213;
        Fri, 17 Jan 2020 14:06:13 -0800 (PST)
Received: from [192.168.43.134] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id r21sm13011149ljn.64.2020.01.17.14.06.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 14:06:12 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: [BUG] io_uring
Message-ID: <2e58fed4-d95f-3d69-b938-a8f77bf96102@gmail.com>
Date:   Sat, 18 Jan 2020 01:05:31 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HmttN9nzqtDcO3ETrblAEVdoyXMH6WUWD"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HmttN9nzqtDcO3ETrblAEVdoyXMH6WUWD
Content-Type: multipart/mixed; boundary="Ow6U61x3nb0bryUdNU9DjPrPvd7VKE1Zz";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Message-ID: <2e58fed4-d95f-3d69-b938-a8f77bf96102@gmail.com>
Subject: [BUG] io_uring

--Ow6U61x3nb0bryUdNU9DjPrPvd7VKE1Zz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

I'm hitting a bug with yesterday's for-next (e.g. 126c20adbd98f2eff00c837=
afc).
I'll debug it in several days, if nobody would do it by then.

kernel: yesterday's for-next (e.g. 126c20adbd98f2eff00c837afc)
How to reproduce: run ./file-update in a loop (for me 10th run hit the pr=
oblem)


[  303.287859] Running test ./file-update
[  303.600280] BUG: kernel NULL pointer dereference, address: 00000000000=
000e4
[  303.600290] #PF: supervisor write access in kernel mode
[  303.600292] #PF: error_code(0x0002) - not-present page
[  303.600294] PGD 0 P4D 0
[  303.600301] Oops: 0002 [#1] PREEMPT SMP PTI
[  303.600307] CPU: 4 PID: 252 Comm: kworker/4:2 Not tainted
5.5.0-rc6-00618-gd22ad6beb885-dirty #162
[  303.600309] Hardware name: Dell Inc. Inspiron 15 7000 Gaming/065C71, B=
IOS
01.00.03 01/10/2017
[  303.600326] Workqueue: events io_ring_file_ref_switch
[  303.600336] RIP: 0010:_raw_spin_lock_irqsave+0x31/0x60
[  303.600339] Code: 89 e5 41 54 53 48 89 fb 9c 58 0f 1f 44 00 00 49 89 c=
4 fa 66
0f 1f 44 00 00 bf 01 00 00 00 e8 66 9a 77 ff 31 c0 ba 01 00 00 00 <f0> 0f=
 b1 13
75 08 5b 4c 89 e0 41 5c 5d c3 89 c6 48 89 df e8 07 3c
[  303.600341] RSP: 0018:ffff9fc30049fda0 EFLAGS: 00010046
[  303.600344] RAX: 0000000000000000 RBX: 00000000000000e4 RCX: 000000000=
0000000
[  303.600346] RDX: 0000000000000001 RSI: ffff96976d818eb0 RDI: ffffffffa=
896d24d
[  303.600347] RBP: ffff9fc30049fdb0 R08: 000073746e657665 R09: 808080808=
0808080
[  303.600349] R10: 0000000000000018 R11: fefefefefefefeff R12: 000000000=
0000282
[  303.600351] R13: 00000000000000e4 R14: ffff96976652ea00 R15: 000000000=
00000d0
[  303.600354] FS:  0000000000000000(0000) GS:ffff96976f500000(0000)
knlGS:0000000000000000
[  303.600355] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  303.600357] CR2: 00000000000000e4 CR3: 00000001cf00a003 CR4: 000000000=
03606e0
[  303.600360] Call Trace:
[  303.600376]  skb_dequeue+0x1d/0x70
[  303.600380]  io_ring_file_ref_switch+0x85/0x280
[  303.600391]  process_one_work+0x1e6/0x3c0
[  303.600395]  worker_thread+0x4a/0x3d0
[  303.600401]  kthread+0x105/0x140
[  303.600404]  ? process_one_work+0x3c0/0x3c0
[  303.600407]  ? kthread_park+0x90/0x90
[  303.600411]  ret_from_fork+0x35/0x40
[  303.600416] Modules linked in: ccm snd_hda_codec_realtek
snd_hda_codec_generic i915 iwlmvm mac80211 x86_pkg_temp_thermal intel_pow=
erclamp
coretemp kvm_intel kvm snd_hda_codec_hdmi i2c_algo_bit irqbypass drm_kms_=
helper
libarc4 crct10dif_pclmul iwlwifi joydev crc32_pclmul mousedev
ghash_clmulni_intel snd_hda_intel hid_multitouch snd_intel_dspcfg uvcvide=
o
dell_laptop iTCO_wdt snd_hda_codec ledtrig_audio aesni_intel drm crypto_s=
imd
dell_wmi videobuf2_vmalloc hid_generic intel_rapl_msr iTCO_vendor_support=

dell_smbios videobuf2_memops cryptd dcdbas wmi_bmof cfg80211 glue_helper
videobuf2_v4l2 snd_hda_core dell_wmi_descriptor mxm_wmi intel_cstate
dell_smm_hwmon tpm_crb videobuf2_common snd_hwdep r8169 nls_iso8859_1
intel_uncore tpm_tis videodev nls_cp437 intel_gtt psmouse snd_pcm
intel_rapl_perf agpgart tpm_tis_core input_leds realtek i2c_i801 mei_me
snd_timer libphy mei mc syscopyarea rfkill tpm snd intel_lpss_pci sysfill=
rect
intel_hid intel_lpss processor_thermal_device intel_pch_thermal idma64
[  303.600496]  intel_rapl_common i2c_hid sysimgblt int3403_thermal hid
sparse_keymap soundcore int3402_thermal intel_soc_dts_iosf fb_sys_fops
int3400_thermal evdev battery rng_core mac_hid int340x_thermal_zone
acpi_thermal_rel ac wmi crypto_user ip_tables x_tables ext4 crc16 mbcache=
 jbd2
sd_mod ahci libahci libata scsi_mod xhci_pci serio_raw xhci_hcd atkbd lib=
ps2
crc32c_intel i8042 serio
[  303.600538] CR2: 00000000000000e4
[  303.600544] ---[ end trace b92f8382e98caae3 ]---
[  303.600550] RIP: 0010:_raw_spin_lock_irqsave+0x31/0x60
[  303.600553] Code: 89 e5 41 54 53 48 89 fb 9c 58 0f 1f 44 00 00 49 89 c=
4 fa 66
0f 1f 44 00 00 bf 01 00 00 00 e8 66 9a 77 ff 31 c0 ba 01 00 00 00 <f0> 0f=
 b1 13
75 08 5b 4c 89 e0 41 5c 5d c3 89 c6 48 89 df e8 07 3c
[  303.600555] RSP: 0018:ffff9fc30049fda0 EFLAGS: 00010046
[  303.600557] RAX: 0000000000000000 RBX: 00000000000000e4 RCX: 000000000=
0000000
[  303.600559] RDX: 0000000000000001 RSI: ffff96976d818eb0 RDI: ffffffffa=
896d24d
[  303.600560] RBP: ffff9fc30049fdb0 R08: 000073746e657665 R09: 808080808=
0808080
[  303.600562] R10: 0000000000000018 R11: fefefefefefefeff R12: 000000000=
0000282
[  303.600564] R13: 00000000000000e4 R14: ffff96976652ea00 R15: 000000000=
00000d0
[  303.600567] FS:  0000000000000000(0000) GS:ffff96976f500000(0000)
knlGS:0000000000000000
[  303.600568] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  303.600570] CR2: 00000000000000e4 CR3: 00000001cf00a003 CR4: 000000000=
03606e0
[  303.600578] note: kworker/4:2[252] exited with preempt_count 1


--=20
Pavel Begunkov


--Ow6U61x3nb0bryUdNU9DjPrPvd7VKE1Zz--

--HmttN9nzqtDcO3ETrblAEVdoyXMH6WUWD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4iL7EACgkQWt5b1Glr
+6VUYw//eb0O6tO6S7/qO3OxMTPMhVkg2fqUY10KOmJCOb/Z35njPyf6iNwkZJSa
trXjACnNjhfva1/+Rl37mEteDOdsWIjl8iZLomj6pLFwzIDCoRUh7noU7azBhUOm
4fCLisVtNTJWGxhYEJ2d8TzvGBwjnupZoG+eFdaGuMfBeOYgMLGfGWaXkCHdRJ0J
kum4F+3C9fv2usziScSFaYCl28eKgpT5I0uJx3Wx1t1B/GuGMineXAy30z+bDFlI
+ScogMUcJC3i1TmAfXEFD/ZwPEN9hWcgZlog58eLy+J7/v8LVzF3TSKaWg/18h7e
1GGllnAi3TwNR7eRM7bRQ3hso67i7HfdADpErz2f+UHuYFl7ez2P2GMopTHlFnSl
sAsUdQHOkz0+D/kAawD7trBFjh3bLB6O7CMZ0gIC8AoKG4Zzy/79TeA+PCP/BMkK
7udtQERoA2MeXFOphlsOXvodMwEvr+fIvT+aGmdvEfAuYTxh3/hXLJA/jyzVvz0T
1CRxO+KMNbxrWW0nl/MPSOD8sLALGbLEHSG5hdCTIzbTPJzrvm/QyZZYLCePSvjA
NkSKFnzOk27sgEyyEvWKhr6b+0HTRR4Rj857qPgDjrEdzrJNIOFyebZfttmLsyyR
DXS+SpqdKbi/aZudi05/8DY+lasukk5ALzrIOCacYAwCrEVmzM8=
=Pu9c
-----END PGP SIGNATURE-----

--HmttN9nzqtDcO3ETrblAEVdoyXMH6WUWD--
